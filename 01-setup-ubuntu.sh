#!/usr/bin/env bash

set -e -x

#Create local folders
mkdir -p ${HOME}/bin || true
mkdir -p ${HOME}/git/personal || true
mkdir -p ${HOME}/git/public || true

#Initial update and upgrade
sudo apt update
sudo apt purge -y unattended-upgrades
sudo apt upgrade -y

#Install my prereqs
sudo apt install -y apt-transport-https curl gdebi-core timeshift make git jq traceroute



echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections

sudo apt install -y \
build-essential \
ca-certificates \
conky-all \
deluge \
ffmpegthumbnailer \
folder-color-common \
folder-color-switcher \
gnome-screenshot \
gnome-tweaks \
gparted \
gstreamer1.0-libav \
htop \
imagemagick \
linux-headers-$(uname -r) \
mangohud \
nemo-dropbox \
nemo-image-converter \
nemo-media-columns \
nemo-preview \
nemo-share \
nemo-terminal \
openssh-server \
python-is-python3 \
python3-gpg \
python3-pip \
python3-tk \
python3-venv \
qdirstat \
sshpass \
vim \
vlc \
wakeonlan

echo "export PATH=${PATH}:/home/${USER}/.local/bin:/home/${USER}/bin" >> ~/.bashrc
