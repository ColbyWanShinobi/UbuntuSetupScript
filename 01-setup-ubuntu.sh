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

#WebP Support for 22.04 only
if [[ $(apt search webp-pixbuf-loader | grep installed) != "installed" ]];then
  wget https://launchpad.net/ubuntu/+source/webp-pixbuf-loader/0.0.5-5/+build/24125572/+files/webp-pixbuf-loader_0.0.5-5_amd64.deb -O ${HOME}/Downloads/webp-pixbuf-loader_0.0.5-5_amd64.deb
  yes | sudo gdebi ${HOME}/Downloads/webp-pixbuf-loader_0.0.5-5_amd64.deb
fi

echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections

sudo apt install -y \
blueman \
build-essential \
ca-certificates \
chrome-gnome-shell \
conky-all \
deluge \
ffmpegthumbnailer \
folder-color \
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
nautilus-gtkhash \
nautilus-image-converter \
openssh-server \
pavucontrol \
python-is-python3 \
python3-gpg \
python3-pip \
python3-tk \
python3.10-venv \
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


#Remove Firefox snap
#https://www.omgubuntu.co.uk/2022/04/how-to-install-firefox-deb-apt-ubuntu-22-04
#sudo snap remove firefox
#if [ ! -f "/etc/apt/preferences.d/mozilla-firefox" ]; then
#  echo '
#    Package: *
#    Pin: release o=LP-PPA-mozillateam
#    Pin-Priority: 501
#  ' | sudo tee /etc/apt/preferences.d/mozilla-firefox
#  sudo add-apt-repository -y ppa:mozillateam/ppa
#fi
#distro_codename=$(grep DISTRIB_CODENAME /etc/lsb-release | cut -f2 -d=)
#if [ ! -f "/etc/apt/apt.conf.d/51unattended-upgrades-firefox" ]; then
#  echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' | sudo tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox
#  sudo apt update
#fi

#https://towardsdatascience.com/installing-multiple-alternative-versions-of-python-on-ubuntu-20-04-237be5177474

echo "export PATH=${PATH}:/home/${USER}/.local/bin:/home/${USER}/bin" >> ~/.bashrc
