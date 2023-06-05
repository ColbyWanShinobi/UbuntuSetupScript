#!/usr/bin/env bash

set -e -x

#Install VSCode
if [ ! -x "$(command -v code)" ];then
  wget https://az764295.vo.msecnd.net/stable/8fa188b2b301d36553cbc9ce1b0a146ccb93351f/code_1.73.0-1667318785_amd64.deb -O ${HOME}/Downloads/vscode.deb
  yes | sudo gdebi ${HOME}/Downloads/vscode.deb
fi