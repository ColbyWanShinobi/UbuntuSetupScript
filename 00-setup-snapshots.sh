#!/usr/bin/env bash

set -e -x

#Initial update and upgrade
sudo apt update
sudo apt upgrade -y

#Install my prereqs
sudo apt install -y apt-transport-https curl gdebi-core timeshift make git jq

#TODO Install Timeshift APT (ONLY IF ROOT IS BTRFS)
if [ `stat --format=%i /` -eq 256 ];then
  #stat -f --format=%T /path
  echo "Found a BTRFS partition, so setting up snapshot support..."
  if [ ! -d "${HOME}/git/public/timeshift-autosnap-apt" ]; then
    git clone https://github.com/wmutschl/timeshift-autosnap-apt.git ${HOME}/git/public/timeshift-autosnap-apt
    cd ${HOME}/git/public/timeshift-autosnap-apt
    sudo make install
  fi
fi
