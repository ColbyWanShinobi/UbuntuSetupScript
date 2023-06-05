#!/usr/bin/env bash

set -e -x

#Install Lutris
if [ ! -x "$(command -v lutris)" ];then
  wget https://github.com/lutris/lutris/releases/download/v0.5.11/lutris_0.5.11_all.deb -O ${HOME}/Downloads/lutris.deb
  yes | sudo gdebi ${HOME}/Downloads/lutris.deb
fi