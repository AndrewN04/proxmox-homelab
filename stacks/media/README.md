# Media Stack

- Gluetun (ProtonVPN WireGuard, port forwarding on)
- qBittorrent (forced through Gluetun namespace)
- qSticky (sync forwarded port → qB listen port)
- Sonarr, Radarr, Prowlarr, Bazarr
- Jellyfin (Quick Sync: /dev/dri)
- Jellyseerr

Notes:
- Ensure `/data` is mounted (NFS from OMV) before starting.
- Copy `.env.example` → `.env` and fill Proton WireGuard values.
- `gluetun/config.toml.example` → `gluetun/config.toml` (API key auth for qSticky)
