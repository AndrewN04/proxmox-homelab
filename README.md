# Proxmox Homelab: OMV + Docker Media Stack + VPN qB + qSticky + Jellyfin + RomM + Crafty

This repo is a **publishable skeleton** (no secrets) for a security-first homelab on **Proxmox VE** with:

- **OMV VM** (8TB data disk passthrough) + Docker stacks:
  - Media automation (\*arr) + Jellyfin
  - **Gluetun (ProtonVPN WireGuard)** + **qBittorrent** + **qSticky** (port forward sync)
  - **RomM** (ROM Manager) + MariaDB
- **Infra VM**: WireGuard remote admin + Nginx Proxy Manager (LAN/VPN only)
- **Games VM**: Crafty Controller + Minecraft servers

> ✅ All secrets/keys/passwords are replaced with examples and stored in `*.env.example` / `*.example` files.  
> ❌ Do not commit real secrets to GitHub.

---

## Quick start (what to do with this repo)

1. Read docs in order:
   - `docs/01-architecture.md`
   - `docs/02-proxmox.md`
   - `docs/03-omv-storage.md`
   - `docs/04-docker-host.md`
   - `docs/05-media-stack.md`
   - `docs/06-romm.md`
   - `docs/07-infra.md`
   - `docs/08-games-crafty.md`
2. Copy example env files and fill in values on the correct VM:
   - `compose/*/.env.example` → `compose/*/.env`
3. Bring up stacks:

   ```bash
   cd compose/media && docker compose up -d
   cd ../romm && docker compose up -d
   ```

4. Run validations:

   ```bash
   sudo bash scripts/validate-vpn-leak.sh
   sudo bash scripts/validate-hardlinks.sh
   sudo bash scripts/validate-stacks.sh
   ```

---

## Repo layout

- `docs/` — step-by-step runbook (publishable)
- `compose/` — docker-compose templates (no secrets)
- `scripts/` — validation + troubleshooting helpers
- `.gitignore` — prevents accidental secret commits

---

## Security boundaries (high level)

- **WAN exposed (recommended minimal):**
  - WireGuard UDP `51820` (to Infra VM)
  - Minecraft TCP `25565` (to Games VM) _(only if you truly need public access)_
- **LAN/VPN only:**
  - Proxmox UI `8006`
  - OMV UI, Docker service UIs (Jellyfin, \*arr, qB, RomM)
  - Nginx Proxy Manager Admin `81`
  - Crafty Panel `8443`

---

## Sources (official docs used)

See `docs/90-sources.md`.
