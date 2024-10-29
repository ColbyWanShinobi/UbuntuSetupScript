#! /bin/bash

sudo dpkg --add-architecture i386
sudo apt update
sudo apt install -y wget
mkdir -p ~/faugus-launcher
wget -P ~/faugus-launcher https://github.com/Faugus/faugus-launcher/releases/download/v1.1-1/faugus-launcher_1.1-1_amd64.deb
wget -P ~/faugus-launcher https://github.com/Faugus/faugus-launcher/releases/download/v1.1-1/python3-umu-launcher_1.1.3-1_amd64.deb
wget -P ~/faugus-launcher https://github.com/Faugus/faugus-launcher/releases/download/v1.1-1/umu-launcher_1.1.3-1_all.deb
sudo apt install -y ~/faugus-launcher/*.deb
