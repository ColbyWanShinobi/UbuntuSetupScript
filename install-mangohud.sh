#!/usr/bin/env bash

set -e -x

FILE_URL=https://github.com/flightlessmango/MangoHud/releases/download/v0.6.9-1/MangoHud-0.6.9.1.r0.g7f94562.tar.gz

#Install MangoHud
#if [ ! -x "$(command -v discord)" ];then
  wget ${FILE_URL} -O ${HOME}/Downloads/mangohud.tar.gz
  tar -xvf ${HOME}/Downloads/mangohud.tar.gz -C ${HOME}/Downloads/
  cd ${HOME}/Downloads/MangoHud
  ./mangohud-setup.sh install
#fi
