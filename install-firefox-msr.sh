#!/usr/bin/env bash

set -e -x

#Remove Firefox snap
#https://www.omgubuntu.co.uk/2022/04/how-to-install-firefox-deb-apt-ubuntu-22-04

#sudo snap remove firefox
if [[ ! -f "/etc/apt/preferences.d/mozilla-firefox" ]]; then
  echo '
    Package: *
    Pin: release o=LP-PPA-mozillateam
    Pin-Priority: 501
  ' | sudo tee /etc/apt/preferences.d/mozilla-firefox
fi

#if [[ ! -f "/etc/apt/preferences.d/nosnap.pref" ]]; then
#  echo '
#    Package: snapd
#    Pin: release a=*
#    Pin-Priority: -10
#  ' | sudo tee /etc/apt/preferences.d/mozilla-firefox
#fi

sudo add-apt-repository -y ppa:mozillateam/ppa

distro_codename=$(grep DISTRIB_CODENAME /etc/lsb-release | cut -f2 -d=)
if [ ! -f "/etc/apt/apt.conf.d/51unattended-upgrades-firefox" ]; then
  echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' | sudo tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox
  sudo apt update
fi

#sudo apt purge -y snapd 
