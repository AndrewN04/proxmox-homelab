# 01. Architecture

## Hardware (example target)

- Intel i5-9500 (6c/6t, UHD 630 iGPU)
- 32GB DDR4
- 500GB NVMe (Proxmox + VM disks)
- 8TB HDD (passed through to OMV VM for `/data`)

## Network plan (example)

- LAN subnet: `192.168.4.0/24`
- Gateway: `192.168.4.1`
- Proxmox host: `192.168.4.210`
- OMV VM: `192.168.4.21`
- Infra VM: `192.168.4.22`
- Games VM: `192.168.4.23`

> Replace with your real addresses. Use DHCP reservations in your router.

## VM roles

### OMV VM (NAS + Docker)

Runs:

- Jellyfin
- Sonarr / Radarr / Prowlarr / Bazarr / Jellyseerr
- Gluetun + qBittorrent + qSticky
- RomM + MariaDB

### Infra VM (remote admin + reverse proxy)

Runs:

- WireGuard server (remote admin entrypoint)
- Nginx Proxy Manager (LAN/VPN only)

### Games VM

Runs:

- Crafty Controller
- Minecraft servers

## Storage layout (TRaSH-style)

Single filesystem for hardlinks/atomic moves:

- `/data/torrents` (downloads)
- `/data/media` (library)
- `/data/appdata` (container configs)
- `/data/roms` (RomM library)

Example:

```text
/data
├── appdata
├── media
│   ├── movies
│   └── tv
├── roms
└── torrents
    ├── incomplete
    └── complete
```
