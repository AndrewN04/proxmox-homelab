# Games Stack (Games VM)

- Crafty Controller (panel LAN/WG only)
- Minecraft server(s) managed by Crafty
- Router forwards ONLY TCP 25565

Steps:
```bash
docker compose up -d
docker compose ps
```

Security:
- Bind Crafty UI to `192.168.4.203:8443`
- Use firewall rules (see `scripts/firewall/games/`) to allow WAN only to 25565.
