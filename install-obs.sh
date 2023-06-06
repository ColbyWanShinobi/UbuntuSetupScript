#!/usr/bin/env bash

set -e -x

#Install OBS Studio
if [ ! -x "$(command -v obs)" ];then
  sudo add-apt-repository -y ppa:obsproject/obs-studio
fi
sudo apt install -y obs-studio
