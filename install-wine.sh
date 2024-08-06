#!/usr/bin/env bash

set -e -x

#Install Wine
if [ ! -f "/etc/apt/trusted.gpg.d/repository-winehq-keyring.gpg" ]; then
  sudo curl -fsSLo /usr/share/keyrings/winehq.key https://dl.winehq.org/wine-builds/winehq.key
  curl -sS https://dl.winehq.org/wine-builds/winehq.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/repository-winehq-keyring.gpg
  sudo apt-add-repository 'https://dl.winehq.org/wine-builds/ubuntu/' -y
fi
sudo apt update
sudo dpkg --add-architecture i386
sudo apt install --install-recommends winehq-staging -y

#sudo dpkg --add-architecture i386 && sudo apt update && sudo apt install -y wine64 wine32 libasound2-plugins:i386 libsdl2-2.0-0:i386 libdbus-1-3:i386 libsqlite3-0:i386