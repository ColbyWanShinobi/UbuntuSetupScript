#!/usr/bin/env bash

set -e -x

#https://docs.amd.com/bundle/ROCm-Installation-Guide-v5.3/page/Introduction_to_ROCm_Installation_Guide_for_Linux.html
#https://gpuopen.com/learn/amd-lab-notes/amd-lab-notes-rocm-installation-readme/

AMDGPU_BASE_URL="https://repo.radeon.com/amdgpu/latest/ubuntu"
ROCM_BASE_URL="https://repo.radeon.com/rocm/apt/debian/"

#Install Kernel Headers
sudo apt update
sudo apt install -y linux-headers-`uname -r` linux-modules-extra-`uname -r` initramfs-tools

#Add AMDGPU Repo Key
wget -q -O - https://repo.radeon.com/rocm/rocm.gpg.key | sudo apt-key add -

#Add AMDGPU Repo
if [ ! -f "/etc/apt/sources.list.d/amdgpu.list" ]; then
  echo 'deb [arch=amd64] https://repo.radeon.com/amdgpu/latest/ubuntu jammy main' | sudo tee /etc/apt/sources.list.d/amdgpu.list
fi
sudo apt update

#Install Kernel-mode Driver
sudo apt install -y amdgpu-dkms

#Add ROCm Stack Repo
if [ ! -f "/etc/apt/sources.list.d/rocm.list" ]; then
  echo 'deb [arch=amd64] https://repo.radeon.com/rocm/apt/debian/ jammy main' | sudo tee /etc/apt/sources.list.d/rocm.list
fi
sudo apt update
sudo apt install -y rocm-hip-sdk5.5.0 rocm-opencl-sdk5.5.0 miopen-hip5.5.0

#Update library env var
echo "export LD_LIBRARY_PATH=/opt/rocm-5.5.0/lib:/opt/rocm-5.5.0/lib64" >> ~/.profile

#Add the user to the "render" group
sudo usermod -a -G render ${USER}

#You need to reboot for all of this to properly take effect.
