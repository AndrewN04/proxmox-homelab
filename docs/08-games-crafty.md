# 08. Games VM (Crafty + Minecraft)

Crafty requires:

- `8443/tcp` for panel access
- Minecraft server ports (default 25565/tcp for a single Java server)
- optional Dynmap port `8123/tcp`

Recommendation:

- Expose Crafty panel to LAN/VPN only
- Expose Minecraft port to WAN only if needed

Bring up:

```bash
cd compose/games
docker compose up -d
```
