#!/usr/bin/env bash
set -euo pipefail

echo "[+] Docker versions"
docker --version
docker compose version

echo "[+] Checking /data mount (Apps VM only)"
if mountpoint -q /data; then
  df -h /data
else
  echo "WARN: /data is not mounted. (Expected on Apps VM.)"
fi

echo "[+] Compose config sanity"
for f in stacks/*/docker-compose.yml; do
  echo " - $f"
  docker compose -f "$f" config >/dev/null
done

echo "[+] Done"
