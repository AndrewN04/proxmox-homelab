# 07. Infra VM (WireGuard + Nginx Proxy Manager)

## WireGuard (remote admin)

Goal: remote access to LAN services without exposing admin UIs to WAN.

Recommended WAN port-forward:

- UDP `51820` → `<INFRA_IP>:51820`

Bring up:

```bash
cd compose/infra
docker compose up -d
```

## Nginx Proxy Manager

Keep NPM admin `81/tcp` LAN/VPN only.
You can still use NPM internally for clean hostnames and TLS on LAN/VPN.
