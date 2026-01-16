# 03. OMV + Storage (8TB passthrough)

## Pass the 8TB disk through to the OMV VM (Proxmox host)

Identify the disk by ID (do not use /dev/sdX):

```bash
ls -l /dev/disk/by-id/
lsblk -o NAME,SIZE,MODEL,SERIAL,TYPE,MOUNTPOINT
```

Attach to OMV VM (example):

```bash
qm set <OMV_VMID> -scsi1 /dev/disk/by-id/<DISK_BY_ID>
qm set <OMV_VMID> -scsihw virtio-scsi-single
```

## OMV install

Install OMV on Debian using the official OMV install method (see sources doc).
After install:

- Access OMV UI on LAN.
- Format the 8TB disk as **ext4**
- Mount it (OMV will create a mountpoint under `/srv/dev-disk-by-uuid-...`)

## Create `/data` structure (on OMV VM)

```bash
mkdir -p <OMV_DATA_MOUNTPOINT>/data/{torrents/{incomplete,complete},media/{movies,tv},appdata,roms,backups}
ln -sfn <OMV_DATA_MOUNTPOINT>/data /data
```

## Permissions (least surprise)

Create a dedicated user/group used by containers:

```bash
groupadd -g 1000 media || true
useradd  -u 1000 -g 1000 -m -s /bin/bash media || true
chown -R 1000:1000 /data
chmod -R u+rwX,g+rwX,o-rwx /data
```
