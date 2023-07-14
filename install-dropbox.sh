#!/usr/bin/env bash

set -e -x

#Install Dropbox
if [ ! -x "$(command -v dropbox)" ];then
  sudo apt-key export 5044912E | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/dropbox.gpg
  wget https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2020.03.04_amd64.deb -O ${HOME}/Downloads/dropbox.deb
  yes | sudo gdebi ${HOME}/Downloads/dropbox.deb
fi
