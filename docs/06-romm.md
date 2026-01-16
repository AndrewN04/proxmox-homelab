# 06. RomM (ROM Manager)

RomM quick start uses:

- `rommapp/romm`
- `mariadb`
- volumes for resources + cached background tasks

## Setup order

1. Copy `compose/romm/.env.example` → `compose/romm/.env`
2. Generate a random `ROMM_AUTH_SECRET_KEY` (see env example)
3. (Optional but recommended) add metadata provider API keys
4. Bring it up:

   ```bash
   cd compose/romm
   docker compose up -d
   ```

## ROM library path

This repo assumes your library is on OMV:

- host path: `/data/roms`
- container path: `/romm/library`

Adjust if you prefer a different folder structure, but keep it on the 8TB disk.
