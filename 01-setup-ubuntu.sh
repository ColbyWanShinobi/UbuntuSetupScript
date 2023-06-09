#!/usr/bin/env bash

set -e -x

#Create local folders
mkdir -p ${HOME}/bin
mkdir -p ${HOME}/git/personal
mkdir -p ${HOME}/git/public

#Move Show Apps Button
gsettings set org.gnome.shell.extensions.dash-to-dock show-apps-at-top true

#Use dark theme
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

#ALways show thhumbnail previews in Nautilus
dconf write /org/gnome/nautilus/preferences/show-image-thumbnails '"always"'


#Initial update and upgrade
sudo apt update
sudo apt upgrade -y

#Install my prereqs
sudo apt install -y apt-transport-https curl gdebi-core timeshift make git jq 

#WebP Support for 22.04 only
if [[ $(apt search webp-pixbuf-loader | grep installed) != "installed" ]];then
  wget https://launchpad.net/ubuntu/+source/webp-pixbuf-loader/0.0.5-5/+build/24125572/+files/webp-pixbuf-loader_0.0.5-5_amd64.deb -O ${HOME}/Downloads/webp-pixbuf-loader_0.0.5-5_amd64.deb
  yes | sudo gdebi ${HOME}/Downloads/webp-pixbuf-loader_0.0.5-5_amd64.deb
fi

echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
sudo apt install -y vim build-essential conky-all linux-headers-$(uname -r) python-is-python3 python3-tk mangohud ubuntu-restricted-extras vlc ffmpegthumbnailer gnome-tweaks gnome-shell-extension-manager chrome-gnome-shell gstreamer1.0-libav gparted qdirstat python3.10-venv deluge gnome-screenshot pavucontrol blueman openssh-server



#Replace PulseAudio with PipeWire
#This won't be necessary in versions after 22.04
#sudo apt install -y pipewire-audio-client-libraries libspa-0.2-bluetooth libspa-0.2-jack wireplumber libpipewire-0.3-dev
#sudo apt remove -y pulseaudio-module-bluetooth
#systemctl --user --now enable wireplumber.service


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

#Download a bunch of git repos for later
if [ ! -d "${HOME}/git/public/obs-gstreamer" ]; then
  git clone https://github.com/fzwoch/obs-gstreamer.git ${HOME}/git/public/obs-gstreamer
  #sudo cp ${HOME}/Downloads/obs-gstreamer/linux/obs-gstreamer.so /usr/lib/x86_64-linux-gnu/obs-plugins/
  #sudo apt install cmake libobs-dev libvulkan-dev libgl-dev libx11-dev libxcb1-dev libwayland-client++0
fi

if [ ! -d "${HOME}/git/public/Complete-Single-GPU-Passthrough" ]; then
  git clone https://github.com/QaidVoid/Complete-Single-GPU-Passthrough.git ${HOME}/git/public/Complete-Single-GPU-Passthrough
fi

if [ ! -d "${HOME}/git/public/OSX-KVM" ]; then
  git clone https://github.com/kholia/OSX-KVM.git ${HOME}/git/public/OSX-KVM
fi

if [ ! -d "${HOME}/git/public/macOS-Simple-KVM" ]; then
  git clone https://github.com/foxlet/macOS-Simple-KVM.git ${HOME}/git/public/macOS-Simple-KVM
fi

if [ ! -d "${HOME}/git/public/obs-pipewire-audio-capture" ]; then
  #https://ubuntuhandbook.org/index.php/2022/04/pipewire-replace-pulseaudio-ubuntu-2204/
  git clone https://github.com/dimtpap/obs-pipewire-audio-capture.git ${HOME}/git/public/obs-pipewire-audio-capture
fi

if [ ! -d "${HOME}/git/public/linux-apfs-rw" ]; then
  git clone https://github.com/linux-apfs/linux-apfs-rw.git ${HOME}/git/public/linux-apfs-rw
fi

if [ ! -d "${HOME}/git/public/lug-helper" ]; then
  git clone https://github.com/starcitizen-lug/lug-helper.git ${HOME}/git/public/lug-helper
fi

#https://towardsdatascience.com/installing-multiple-alternative-versions-of-python-on-ubuntu-20-04-237be5177474
