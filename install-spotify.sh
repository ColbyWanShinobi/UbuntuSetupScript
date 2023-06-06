#!/usr/bin/env bash

set -e -x

#Install Spotify
if [ ! -f "/etc/apt/trusted.gpg.d/spotify.gpg" ]; then
  curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg


fi
if [ ! -f "/etc/apt/sources.list.d/spotify.list" ]; then
  echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
fi

sudo apt update
sudo apt install -y spotify-client
