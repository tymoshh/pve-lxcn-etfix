#!/bin/bash

echo "Fixing networking for Ubuntu 20.04 LXC..."

# 1. Create or replace Netplan config
echo "Creating Netplan DHCP config..."
cat <<EOF | sudo tee /etc/netplan/10-lxc.yaml
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: true
EOF

# 2. Enable and start systemd-networkd
echo "Enabling systemd-networkd..."
sudo systemctl enable systemd-networkd --now

# 3. Disable and clean cloud-init (prevents overwriting netplan)
echo "Disabling cloud-init..."
sudo systemctl disable cloud-init
sudo cloud-init clean

# 4. Apply Netplan config
echo "Applying Netplan config..."
sudo netplan apply

# 5. Output current network status
echo "Network interfaces:"
ip a

echo "Routing table:"
ip r

echo "DNS configuration:"
cat /etc/resolv.conf

echo "Done. You should now have internet access. Rebooting is recommended."
