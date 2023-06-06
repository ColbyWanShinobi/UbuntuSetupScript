#!/usr/bin/env bash

set -e -x

#Install Spotify
if [ ! -f "/etc/apt/trusted.gpg.d/repository-spotify-com-keyring.gpg" ]; then
  curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/repository-spotify-com-keyring.gpg
fi
if [ ! -f "/etc/apt/sources.list.d/spotify.list" ]; then
  echo "deb [signed-by=/etc/apt/trusted.gpg.d/repository-spotify-com-keyring.gpg arch=amd64] http://repository.spotify.com stable non-free"| sudo tee /etc/apt/sources.list.d/spotify.list
fi
