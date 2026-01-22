# Port Policy

**WAN-exposed ONLY**
- WireGuard UDP 51820 → Apps VM (192.168.4.202)
- Minecraft TCP 25565 → Games VM (192.168.4.203)

**Everything else: LAN-only and/or WireGuard-only**

## Recommended bindings (host IP bindings)
Bind admin UIs to the LAN IP to avoid accidental exposure:
- Apps VM: `192.168.4.202:<port>:<port>`
- Games VM: `192.168.4.203:<port>:<port>`

Router forwards: ONLY 51820/udp and 25565/tcp.
