#!/usr/bin/env bash
set -euo pipefail

DEST="/data/appdata/games01/panel"
STAMP="$(date +%F)"
KEEP_DAYS=30

mountpoint -q /data || { echo "FATAL: /data is not mounted — aborting" >&2; exit 1; }
mkdir -p "$DEST"
chmod 700 "$DEST"

# Database. --single-transaction keeps InnoDB consistent without locking the Panel out.
TMP_DB="$(mktemp -p "$DEST" --suffix=.sql.gz ".panel_${STAMP}.XXXXXX")"
mysqldump --single-transaction --routines --triggers panel | gzip -c > "$TMP_DB"
mv -f "$TMP_DB" "${DEST}/panel_${STAMP}.sql.gz"

# .env — APP_KEY lives here and is NOT recoverable from anywhere else.
TMP_ENV="$(mktemp -p "$DEST" --suffix=.tgz ".panelenv_${STAMP}.XXXXXX")"
tar czf "$TMP_ENV" -C /var/www/pterodactyl .env
mv -f "$TMP_ENV" "${DEST}/panelenv_${STAMP}.tgz"

chmod 600 "${DEST}/panel_${STAMP}.sql.gz" "${DEST}/panelenv_${STAMP}.tgz"
find "$DEST" -type f \( -name 'panel_*.sql.gz' -o -name 'panelenv_*.tgz' \) -mtime "+${KEEP_DAYS}" -delete
logger -t panel-backup "panel backup complete: ${DEST}/panel_${STAMP}.sql.gz"
