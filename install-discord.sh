#!/usr/bin/env bash

set -e -x

#Install Discord
if [ ! -x "$(command -v discord)" ];then
  wget "https://discord.com/api/download?platform=linux&format=deb" -O ${HOME}/Downloads/discord.deb
  yes | sudo gdebi ${HOME}/Downloads/discord*.deb
fi
