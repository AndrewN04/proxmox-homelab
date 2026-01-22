# Games VM Docker port filtering (DOCKER-USER)

Docker can bypass host firewall rules for published ports. Use the DOCKER-USER chain for enforcement.

Policy:
- Allow LAN (192.168.4.0/24) and WireGuard (10.6.0.0/24) to reach Crafty UI (8443) and optional ports.
- Allow WAN only to Minecraft TCP 25565.
- Drop the rest.

See `apply.sh` for a minimal ruleset. Validate with `iptables -S DOCKER-USER`.
