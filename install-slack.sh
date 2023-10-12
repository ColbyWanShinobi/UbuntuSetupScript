#!/usr/bin/env bash

set -e -x

newcmd="slack"
dlurl="https://downloads.slack-edge.com/releases/linux/4.34.121/prod/x64/slack-desktop-4.34.121-amd64.deb"

#Install Slack
if [ ! -x "$(command -v ${newcmd})" ];then
  wget "${dlurl}" -O ${HOME}/Downloads/${newcmd}.deb
  yes | sudo gdebi ${HOME}/Downloads/${newcmd}.deb
fi
