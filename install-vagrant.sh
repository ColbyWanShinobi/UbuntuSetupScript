#!/usr/bin/env bash

set -e -x

if [ ! -f "/usr/share/keyrings/hashicorp-archive-keyring.gpg" ]; then
  curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

fi

if [ ! -f "/etc/apt/sources.list.d/hashicorp.list" ]; then
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
fi

sudo apt update
sudo apt install -y vagrant
