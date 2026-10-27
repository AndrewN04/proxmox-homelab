# proxmox-homelab

Deployable files for a single-host homelab: a Proxmox VE 9 host running a TrueNAS VM and four Ubuntu 24.04 VMs. WireGuard and Nginx Proxy Manager form the edge, downloads run inside a VPN, and the stack covers media, game servers and ROM management.

This repo holds **the files only**: compose stacks, `.env` templates, systemd units, scripts and config templates. The procedure is the build runbook, which is kept outside this repo. It says what to run, in what order, and why each setting is what it is. Every file here is extracted from that runbook. **If the two ever disagree, the runbook is right**, and this repo needs updating.

No secrets are committed. Every `*.example` file holds `<PLACEHOLDER>`s from runbook §3, and `.gitignore` blocks the filled-in versions.

## What runs where

| VM | Role | Services |
|---|---|---|
| `truenas01` | storage | TrueNAS Community Edition 25.10: one pool, one dataset, NFSv4 export mounted as `/data` everywhere, SMB share `nas` |
| `apps01` | edge | WireGuard server (the **only** WAN-facing port, `51820/udp`), Cloudflare DDNS, Nginx Proxy Manager + wildcard cert for `*.lan.a04.dev` |
| `dl01` | downloads, VPN-only | Gluetun (ProtonVPN + port forwarding), qBittorrent (`libtorrentv1`), Prowlarr, qSticky |
| `media01` | media, not behind the VPN | Sonarr, Radarr, Questarr, Recyclarr, Jellyfin, Seerr, Homarr, qui |
| `games01` | games | Pterodactyl Panel + Wings, Fabric Minecraft (Java 25), RomM + MariaDB, playit.gg agent |

## Layout: repo path → where it goes

| Repo path | VM | Destination | Runbook |
|---|---|---|---|
| `compose/npm/` | apps01 | `/opt/compose/npm/` | §9.5 |
| `compose/dl01/` | dl01 | `/opt/compose/dl01/` | §10.4 |
| `compose/media01/` | media01 | `/opt/compose/media01/` | §11.3 |
| `compose/romm/` | games01 | `/opt/compose/romm/` | §12.7 |
| `host/all/netplan/99-static.yaml.example` | all four | `/etc/netplan/99-static.yaml` | §7.3 |
| `host/all/cloud-init/99-disable-network-config.cfg` | all four | `/etc/cloud/cloud.cfg.d/` | §7.3 |
| `host/all/docker/daemon.json` | all four | `/etc/docker/daemon.json` | §7.5 |
| `host/all/shell/dc.bashrc` | all four | append to `~/.bashrc` | §7.5 |
| `host/all/fstab/data.fstab.example` | all four | append to `/etc/fstab` | §9.1 |
| `host/all/backup/appdata-backup.{sh,service,timer}` | all four | `/usr/local/bin/`, `/etc/systemd/system/` | §15.1–15.2 |
| `host/apps01/wireguard/*.conf.example` | apps01 / each client | `/etc/wireguard/wg0.conf`, client devices | §9.2 |
| `host/apps01/ddns/` | apps01 | `/opt/ddns/` + `/etc/systemd/system/` | §9.4 |
| `host/dl01/gluetun/config.toml.example` | dl01 | `/srv/appdata/gluetun/auth/config.toml` | §10.3 |
| `host/media01/recyclarr/recyclarr.yml.example` | media01 | `/srv/appdata/recyclarr/recyclarr.yml` | §11.6 |
| `host/games01/pterodactyl/` | games01 | nginx site, `pteroq.service`, `wings.service` | §12.3–12.4 |
| `host/games01/backup/` | games01 | Panel DB + `.env` backup, Wings backup mirror | §12.5, §15.3 |

## Deploying a stack

`/opt/compose` and every `.env` are root-only by design (runbook §7.5), so copy files in with `sudo`. Don't clone the repo into `/opt/compose`. Example for dl01:

```bash
git clone https://github.com/AndrewN04/proxmox-homelab.git ~/proxmox-homelab
cd ~/proxmox-homelab
sudo mkdir -p /opt/compose/dl01
sudo install -m 644 -o root -g root compose/dl01/docker-compose.yml /opt/compose/dl01/
sudo install -m 600 -o root -g root compose/dl01/.env.example       /opt/compose/dl01/.env
sudo nano /opt/compose/dl01/.env          # replace every <PLACEHOLDER>
cat host/all/shell/dc.bashrc >> ~/.bashrc && source ~/.bashrc
dc dl01 up -d && dc dl01 ps
```

Each compose file reads **all** its values from the `.env` beside it. The runbook's compose blocks write the same values inline as `<PLACEHOLDER>`s, and the content is otherwise identical. Before any `up`, follow the runbook phase for that VM: the firewall rules, directory ownership and post-start settings matter as much as the files.

## Checks

```bash
./scripts/validate.sh          # shell syntax + every compose file renders against its .env.example
./scripts/validate.sh --live   # on a VM: also render the deployed stacks in /opt/compose
```

## Non-negotiables (details in the runbook)

- **Exactly one forwarded port**, `51820/udp` to apps01. Game traffic uses playit.gg tunnels. Never forward 80/443.
- **Bind every published port to the VM's LAN IP** (`"${VM_IP}:port:port"`), never `0.0.0.0`. `ufw-docker` only blocks *public* sources, so the binding and the router are what keep these ports off the internet (§7.4).
- **One `/data` mount, identical path in every container** (TRaSH hardlinks). Never remap to `/downloads` or `/media`.
- **Seeding is permanent** (all qBittorrent limits off), so **qui is mandatory**. It deletes only Arr-category torrents that are no longer hardlinked into the library, after 14 days, with no free-space condition (§11.9).
- **qBittorrent stays on `:libtorrentv1`.** `:latest` is libtorrent 2, which memory-maps every torrent and would OOM dl01.
- **Pterodactyl node: Daemon Port `443`, Wings `api.port: 8080`** behind NPM (§12.4).
- **games01 stays on Ubuntu 24.04** (Panel needs PHP 8.2/8.3), with the `php8.3` package ≥ `8.3.6-0ubuntu0.24.04.13`.
