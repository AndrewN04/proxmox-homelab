# 05. Media Stack (Gluetun + qBittorrent + qSticky + \*arr + Jellyfin)

## Why `/data` mapping matters

To get **hardlinks** and **atomic moves**, downloads and library must be on the **same filesystem**.
Use a single `/data` mount inside the \*arr containers.

## Setup order (recommended)

1. Create Gluetun auth config for qSticky
2. Copy `.env.example` → `.env` and fill in values
3. `docker compose up -d`
4. Access qB WebUI via Gluetun-published port (default `http://<OMV_IP>:8080`).
5. Validate:
   - VPN IP != home IP
   - qB traffic goes through Gluetun
   - qSticky updates the qB listen port
   - Hardlink test passes after first import

## qSticky + Gluetun auth

qSticky requires Gluetun control server auth with routes:

- `GET /v1/portforward`
- `GET /v1/vpn/status`

Use the example file:

- `compose/media/gluetun/config.toml.example` → `compose/media/gluetun/config.toml`

## Validation helpers

See:

- `scripts/validate-vpn-leak.sh`
- `scripts/validate-hardlinks.sh`
- `scripts/validate-stacks.sh`
