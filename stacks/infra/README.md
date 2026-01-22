# Infra Stack

- WireGuard (remote admin VPN)
- Nginx Proxy Manager (internal reverse proxy)

Steps:
```bash
cp .env.example .env
chmod 600 .env
docker compose --env-file .env up -d
docker compose ps
```
