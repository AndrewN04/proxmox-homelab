# Security notes

## Do not commit secrets

- Keep real values in:
  - `compose/*/.env` (gitignored)
  - `compose/media/gluetun/config.toml` (gitignored)
  - Optional: Docker secrets (recommended if you want)

## Safe file permissions (VM side)

```bash
chmod 700 compose/*/secrets || true
chmod 600 compose/*/.env || true
chmod 600 compose/media/gluetun/config.toml || true
```

## WAN exposure

Default posture: **no web UIs exposed to WAN**.

- Prefer **WireGuard** for remote admin access.
- Only port-forward Minecraft if you must.

## Docker + firewall note

Docker-published ports can bypass some host firewalls depending on setup.
If you use a host firewall, enforce inbound restrictions via the `DOCKER-USER` chain.
