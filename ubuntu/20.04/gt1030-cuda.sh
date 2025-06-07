wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.1-1_all.deb
dpkg -i cuda-keyring_1.1-1_all.deb
apt update
apt install -y cuda-toolkit-12-8
#!/bin/bash

CUDA_VERSION=12.8
CUDA_PATH="/usr/local/cuda-${CUDA_VERSION}"
PROFILED_FILE="/etc/profile.d/cuda.sh"

echo "Configuring CUDA ${CUDA_VERSION} environment globally..."

cat <<EOF > "${PROFILED_FILE}"
export PATH=${CUDA_PATH}/bin:\$PATH
export LD_LIBRARY_PATH=${CUDA_PATH}/lib64:\$LD_LIBRARY_PATH
EOF

chmod +x "${PROFILED_FILE}"
echo "Created ${PROFILED_FILE}"

# 2. Append to /etc/environment for non-login shells
if ! grep -q "${CUDA_PATH}/bin" /etc/environment; then
    sed -i "s|^PATH=|PATH=${CUDA_PATH}/bin:|" /etc/environment
    echo "PATH updated in /etc/environment"
fi

if ! grep -q "LD_LIBRARY_PATH" /etc/environment; then
    echo "LD_LIBRARY_PATH=${CUDA_PATH}/lib64" >> /etc/environment
    echo "LD_LIBRARY_PATH added to /etc/environment"
fi

echo "CUDA environment configured system-wide."
