#!/usr/bin/env bash

set -e -x

#Install AMD GPU Drivers
#sudo add-apt-repository ppa:kisak/kisak-mesa -y
#sudo dpkg --add-architecture i386
sudo apt update
sudo apt purge -y libgl1-mesa-dri:i386 mesa-vulkan-drivers mesa-vulkan-drivers:i386