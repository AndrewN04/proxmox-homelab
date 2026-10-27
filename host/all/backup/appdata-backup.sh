#!/usr/bin/env bash
set -euo pipefail

VMNAME="$(hostname -s)"
DEST="/data/appdata/${VMNAME}"
STAMP="$(date +%F)"
KEEP_DAYS=30

# FIX 1: refuse to run if the NAS is not mounted, rather than filling the local disk.
mountpoint -q /data || { echo "FATAL: /data is not mounted — aborting" >&2; exit 1; }

# FIX 2: create the destination.
mkdir -p "$DEST"

# FIX 3: quiesce the stacks so SQLite/Redis state is consistent, then always restart them.
STACKS=(/opt/compose/*/)
restart_stacks() {
  for s in "${STACKS[@]}"; do
    [[ -f "${s}docker-compose.yml" ]] && (cd "$s" && docker compose start >/dev/null 2>&1 || true)
  done
  # FIX 5: a function returns its last command's status, and an EXIT trap that returns
  # non-zero overwrites the script's exit status. Without this, a directory under
  # /opt/compose/ with no docker-compose.yml that sorts last makes systemd report the
  # unit failed on a run that wrote a perfectly good archive.
  return 0
}
trap restart_stacks EXIT

for s in "${STACKS[@]}"; do
  [[ -f "${s}docker-compose.yml" ]] && (cd "$s" && docker compose stop >/dev/null)
done

# FIX 4: write to a temp file first so an interrupted run never leaves a truncated archive
# that looks like a valid backup.
TMP="$(mktemp -p "$DEST" --suffix=.tgz ".appdata_${STAMP}.XXXXXX")"
tar czf "$TMP" -C /srv/appdata .
mv -f "$TMP" "${DEST}/appdata_${STAMP}.tgz"

find "$DEST" -type f -name 'appdata_*.tgz' -mtime "+${KEEP_DAYS}" -delete
logger -t appdata-backup "backup complete: ${DEST}/appdata_${STAMP}.tgz"
