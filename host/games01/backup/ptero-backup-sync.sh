#!/usr/bin/env bash
set -euo pipefail
SRC=/var/lib/pterodactyl/backups
DEST=/data/nas/games/backups
mountpoint -q /data || { echo "FATAL: /data not mounted, aborting" >&2; exit 1; }
mkdir -p "$DEST"
rsync -a --delete "$SRC"/ "$DEST"/
