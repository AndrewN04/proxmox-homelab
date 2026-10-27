#!/usr/bin/env bash
# Pre-deploy checks. Run from anywhere inside the repo.
#   ./scripts/validate.sh         shell syntax + every compose file renders with its .env.example
#   ./scripts/validate.sh --live  also render the deployed stacks in /opt/compose (run on a VM, needs sudo)
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

fail=0
for f in $(git ls-files '*.sh'); do
  bash -n "$f" || { echo "FAIL syntax: $f"; fail=1; }
done

if command -v docker >/dev/null; then
  for d in compose/*/; do
    # .env.example holds <PLACEHOLDER>s that are not valid IPs/ports, so render against dummy values.
    tmp="$(mktemp)"
    sed -E 's/<[^>]+>/placeholder/g; s/^([A-Z0-9_]*_IP)=.*/\1=192.0.2.1/; s/^LAN_CIDR=.*/LAN_CIDR=192.0.2.0\/24/; s/^RENDER_GID=.*/RENDER_GID=999/' \
      "$d.env.example" > "$tmp"
    if docker compose -f "${d}docker-compose.yml" --env-file "$tmp" config -q; then
      echo "ok   $d"
    else
      echo "FAIL $d"; fail=1
    fi
    rm -f "$tmp"
  done
else
  echo "skip compose render: docker not installed here"
fi

if [[ "${1:-}" == "--live" ]]; then
  for d in /opt/compose/*/; do
    sudo test -f "${d}docker-compose.yml" || continue
    sudo docker compose -f "${d}docker-compose.yml" config -q && echo "ok   live $d" || { echo "FAIL live $d"; fail=1; }
  done
fi

exit "$fail"
