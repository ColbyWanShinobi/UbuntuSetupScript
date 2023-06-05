#!/usr/bin/env bash

set -e -x

#https://docs.amd.com/bundle/ROCm-Installation-Guide-v5.3/page/Introduction_to_ROCm_Installation_Guide_for_Linux.html
#https://gpuopen.com/learn/amd-lab-notes/amd-lab-notes-rocm-installation-readme/


export ROCM_REPO_BASEURL="https://repo.radeon.com/rocm/apt/5.4/"
export ROCM_REPO_COMP="ubuntu"
export ROCM_REPO_BUILD="main"

if [ ! -f "/etc/apt/sources.list.d/rocm.list" ]; then
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 9386B48A1A693C5C
  echo "deb [arch=amd64 trusted=yes] ${ROCM_REPO_BASEURL} ${ROCM_REPO_COMP} ${ROCM_REPO_BUILD}" | sudo tee /etc/apt/sources.list.d/rocm.list
fi

sudo apt update

DEBIAN_FRONTEND=noninteractive apt-get install -y 
 libdrm-amdgpu* 
 initramfs-tools 
 libtinfo* 
 rocm-llvm 
 rocm-hip-runtime 
 rocm-hip-sdk 
 roctracer-dev
