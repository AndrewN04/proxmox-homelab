#!/usr/bin/env bash
set -euo pipefail

# NOTE: Replace IFACE if your VM interface isn't eth0.
IFACE="${IFACE:-eth0}"

# Ensure chain exists
sudo iptables -N DOCKER-USER 2>/dev/null || true

# Remove any previous rules from this script by flushing DOCKER-USER cautiously:
# Safer: insert our rules at the top and keep a final RETURN for other rulesets.
# Here we implement a minimal policy for a dedicated VM.

sudo iptables -F DOCKER-USER

# Allow established
sudo iptables -A DOCKER-USER -m conntrack --ctstate RELATED,ESTABLISHED -j RETURN

# Allow LAN + WG to Crafty UI and optional ports
sudo iptables -A DOCKER-USER -i "$IFACE" -s 192.168.4.0/24 -j RETURN
sudo iptables -A DOCKER-USER -i "$IFACE" -s 10.6.0.0/24 -j RETURN

# Allow WAN to Minecraft TCP 25565 only
sudo iptables -A DOCKER-USER -p tcp --dport 25565 -j RETURN

# Drop everything else destined for published ports
sudo iptables -A DOCKER-USER -j DROP

echo "[+] Applied DOCKER-USER rules"
sudo iptables -S DOCKER-USER | sed -n '1,120p'
