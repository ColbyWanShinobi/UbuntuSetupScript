#!/usr/bin/env bash

set -e -x

#Create local folders
mkdir -p ${HOME}/bin || true
mkdir -p ${HOME}/git/personal || true
mkdir -p ${HOME}/git/public || true

#Move Show Apps Button
gsettings set org.gnome.shell.extensions.dash-to-dock show-apps-at-top true

#Use dark theme
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

#Always show thhumbnail previews in Nautilus
dconf write /org/gnome/nautilus/preferences/show-image-thumbnails '"always"'

#Initial update and upgrade
sudo apt update
sudo apt purge -y unattended-upgrades
sudo apt upgrade -y

#Install my prereqs
sudo apt install -y apt-transport-https curl gdebi-core timeshift make git jq traceroute

echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections

sudo apt install -y \
blueman \
build-essential \
ca-certificates \
chrome-gnome-shell \
conky-all \
deluge \
ffmpegthumbnailer \
gnome-screenshot \
gnome-shell-extension-manager \
gnome-tweaks \
gparted \
gstreamer1.0-libav \
htop \
imagemagick \
linux-headers-$(uname -r) \
mangohud \
nautilus-admin \
nautilus-image-converter \
openssh-server \
pavucontrol \
python-is-python3 \
python3-gpg \
python3-pip \
python3-tk \
python3-venv \
qdirstat \
sshpass \
ubuntu-restricted-extras \
vim \
vlc \
wakeonlan

#Replace PulseAudio with PipeWire
#This won't be necessary in versions after 22.04
sudo apt install -y pipewire-audio-client-libraries libspa-0.2-bluetooth libspa-0.2-jack wireplumber libpipewire-0.3-dev
sudo apt remove -y pulseaudio-module-bluetooth
systemctl --user --now enable wireplumber.service

echo "export PATH=${PATH}:/home/${USER}/.local/bin:/home/${USER}/bin" >> ~/.bashrc
