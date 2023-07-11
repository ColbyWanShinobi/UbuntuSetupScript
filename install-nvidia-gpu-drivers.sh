#!/usr/bin/env bash

set -e -x

NEWEST=535
#Install NVIDIA GPU Drivers
sudo add-apt-repository ppa:graphics-drivers/ppa -y
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install -y nvidia-driver-${NEWEST} nvidia-kernel-source-${NEWEST} libvulkan1 libvulkan1:i386
