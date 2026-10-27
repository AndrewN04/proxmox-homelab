#!/usr/bin/env bash
set -euo pipefail
set -a; . /opt/ddns/.env; set +a

IP="$(curl -fsS --max-time 10 https://api.ipify.org)"
[[ "$IP" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]] || { echo "bad IP: $IP" >&2; exit 1; }

REC="$(curl -fsS -X GET \
  "https://api.cloudflare.com/client/v4/zones/${CF_ZONE_ID}/dns_records?type=A&name=${CF_RECORD_NAME}" \
  -H "Authorization: Bearer ${CF_API_TOKEN}" -H "Content-Type: application/json")"

REC_ID="$(jq -r '.result[0].id // empty' <<<"$REC")"
CUR_IP="$(jq -r '.result[0].content // empty' <<<"$REC")"
[[ -n "$REC_ID" ]] || { echo "record ${CF_RECORD_NAME} not found — create it manually first" >&2; exit 1; }
[[ "$CUR_IP" == "$IP" ]] && exit 0

curl -fsS -X PATCH \
  "https://api.cloudflare.com/client/v4/zones/${CF_ZONE_ID}/dns_records/${REC_ID}" \
  -H "Authorization: Bearer ${CF_API_TOKEN}" -H "Content-Type: application/json" \
  --data "$(jq -nc --arg ip "$IP" '{content:$ip, proxied:false}')" >/dev/null

logger -t cf-ddns "updated ${CF_RECORD_NAME}: ${CUR_IP:-none} -> ${IP}"
