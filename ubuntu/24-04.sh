#!/bin/bash

echo "Fixing networking for Ubuntu 24.04 LXC..."

# 1. Create Netplan config
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

# 3. Mask NetworkManager if it exists
if systemctl list-unit-files | grep -q NetworkManager; then
  echo "Masking NetworkManager..."
  sudo systemctl mask NetworkManager
fi

# 4. Disable cloud-init
echo "Disabling cloud-init..."
sudo systemctl disable cloud-init
sudo cloud-init clean

# 5. Apply Netplan
echo "Applying Netplan config..."
sudo netplan apply

# 6. Show current network status
echo "Network interfaces after fix:"
ip a

# 7. Show routing and DNS
echo "Routing table:"
ip r

echo "DNS settings:"
cat /etc/resolv.conf

echo "All done. You may want to 'reboot' the container to ensure everything reloads correctly."
