# Homelab Stack Skeleton (Proxmox + OMV + Debian VMs + Docker Compose)

This repo is a **safe skeleton** (no secrets) for your single-node homelab:

- Proxmox host: `192.168.4.200`
- OMV VM: `192.168.4.201` (SMB for Windows, NFS export for Apps VM)
- Apps VM: `192.168.4.202` (Docker stacks: infra + media + RomM)
- Games VM: `192.168.4.203` (Docker stack: Crafty + Minecraft)

## Principles baked in
- TRaSH-style **single `/data` mount** shared across download client + *arr + libraries (hardlinks/atomic moves).
- Secrets live in `.env` files that are **NOT committed** (copy from `.env.example`).
- LAN/WireGuard-only admin UIs by **binding published ports to the LAN IP** and/or firewalling.

## Repo layout
- `stacks/infra`  → WireGuard (remote admin) + Nginx Proxy Manager (internal)
- `stacks/media`  → Gluetun + qBittorrent + qSticky + Sonarr/Radarr/Prowlarr/Bazarr + Jellyfin + Jellyseerr
- `stacks/romm`   → RomM + database (placeholder; follow RomM docs for final vars)
- `stacks/games`  → Crafty Controller + Minecraft (Fabric-ready)
- `scripts`       → helpers (firewall apply, validate, pin images)
- `docs`          → notes + checklists

## Quick start (after you fill env files)
On each VM:
```bash
cd /opt/homelab   # wherever you clone this repo
cp stacks/<stack>/.env.example stacks/<stack>/.env
chmod 600 stacks/<stack>/.env
docker compose -f stacks/<stack>/docker-compose.yml --env-file stacks/<stack>/.env up -d
```

## Safety
- Do **not** commit `.env` or auth files.
- Do **not** port-forward any admin UIs from your router.
