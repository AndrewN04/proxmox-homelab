# 02. Proxmox VE

## Install

- Install Proxmox VE to the **500GB NVMe** using the official installer ISO.
- Enable VT-x and VT-d (IOMMU) in BIOS/UEFI.

## Post-install updates

```bash
apt update
apt dist-upgrade -y
reboot
```

## Networking

- Use a bridge (`vmbr0`) so VMs are normal LAN devices.

## Firewall baseline

- Keep Proxmox UI `8006/tcp` LAN-only.
- Avoid exposing management services to WAN.

## Create VMs

Create 3 Debian-based VMs:

- OMV VM: 4 vCPU, 12–16GB RAM
- Infra VM: 2 vCPU, 2–4GB RAM
- Games VM: 4 vCPU, 8–10GB RAM

Enable **QEMU Guest Agent** in each VM and install `qemu-guest-agent` inside the guest.
