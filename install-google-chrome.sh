#!/usr/bin/env bash

set -e -x

#Install Google Chrome
if [ ! -x "$(command -v google-chrome)" ];then
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O ${HOME}/Downloads/gchrome.deb
  yes | sudo gdebi ${HOME}/Downloads/gchrome.deb
fi
