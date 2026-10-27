# Append to the admin user's ~/.bashrc on every Ubuntu VM (runbook §7.5).
# /opt/compose and its .env files are root-only, so compose must run as root.
# dc <stack> <compose args…>  e.g.  dc dl01 up -d  ·  dc dl01 ps  ·  dc dl01 logs -f gluetun
dc() { sudo docker compose -f "/opt/compose/$1/docker-compose.yml" "${@:2}"; }
