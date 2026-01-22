# /data Layout (TRaSH-style)

Target: Apps VM mounts OMV NFS export at `/data` (single filesystem).

Example:
- `/data/torrents/...` (downloads)
- `/data/media/movies`
- `/data/media/tv`

Hardlink test:
```bash
mkdir -p /data/test/{src,dst}
echo x > /data/test/src/file
ln /data/test/src/file /data/test/dst/file.link
ls -li /data/test/src/file /data/test/dst/file.link
```
Inodes must match.
