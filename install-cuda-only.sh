#!/usr/bin/env bash

set -e -x

distro=ubuntu2204
arch=x86_64

sudo apt update
sudo apt install -y linux-headers-$(uname -r)
sudo apt-key del 7fa2af80 || yes

wget https://developer.download.nvidia.com/compute/cuda/repos/$distro/$arch/cuda-keyring_1.1-1_all.deb -O ${HOME}/Downloads/cuda-keyring_1.1-1_all.deb
yes | sudo gdebi ${HOME}/Downloads/cuda-keyring_1.1-1_all.deb

sudo apt update
sudo apt install -y cuda nvidia-gds

echo "export PATH=${PATH}:/usr/local/cuda-12.2/bin" >> ~/.bashrc
echo "export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/cuda-12.2/lib64" >> ~/.bashrc
