#!/usr/bin/env bash

set -e -x

URL=http://mirrors.kernel.org/ubuntu/pool/universe/g/gamescope/gamescope_3.11.39-1_amd64.deb
URL2=http://mirrors.kernel.org/ubuntu/pool/universe/libl/libliftoff/libliftoff0_0.3.0-1_amd64.deb

#Install Gamescope
if [ ! -x "$(command -v gamescope)" ];then
  wget "${URL2}" -O ${HOME}/Downloads/libliftoff.deb
  yes | sudo gdebi ${HOME}/Downloads/libliftoff.deb

  wget "${URL}" -O ${HOME}/Downloads/gamescope.deb
  yes | sudo gdebi ${HOME}/Downloads/gamescope.deb
fi
