#!/usr/bin/env bash

set -e -x

#Install nvm
if [ ! -d "$HOME/.nvm" ];then
  wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
fi