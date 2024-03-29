#!/usr/bin/env bash

set -e -x

ROCM_VER=5.6.0

#https://docs.amd.com/bundle/ROCm-Installation-Guide-v5.3/page/Introduction_to_ROCm_Installation_Guide_for_Linux.html
#https://gpuopen.com/learn/amd-lab-notes/amd-lab-notes-rocm-installation-readme/

#Add AMDGPU Repo Key
wget -q -O - https://repo.radeon.com/rocm/rocm.gpg.key | sudo apt-key add -
sudo apt-key export 1A693C5C | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/amd-rocm.gpg

#Add ROCm Stack Repo
if [ ! -f "/etc/apt/sources.list.d/rocm.list" ]; then
  echo 'deb [arch=amd64] https://repo.radeon.com/rocm/apt/debian/ jammy main' | sudo tee /etc/apt/sources.list.d/rocm.list
fi

sudo apt update

#Install Kernel Headers
sudo apt install -y linux-headers-`uname -r` linux-modules-extra-`uname -r` initramfs-tools
sudo apt install -y rocm-hip-sdk${ROCM_VER} rocm-opencl-sdk${ROCM_VER} miopen-hip${ROCM_VER}

#Update library env var
echo "export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/opt/rocm-${ROCM_VER}/lib:/opt/rocm-${ROCM_VER}/lib64" >> ~/.bashrc
#Add the user to the "render" group
sudo usermod -a -G render ${USER}

#You need to reboot for all of this to properly take effect.
