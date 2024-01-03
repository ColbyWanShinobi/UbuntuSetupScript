#!/usr/bin/env bash

set -e -x

CODENAME=$(grep CODENAME /etc/lsb-release | cut -d'=' -f2)
RELEASE=$(grep RELEASE /etc/lsb-release | cut -d'=' -f2)

sudo rm -rfv /etc/apt/keyrings/docker.gpg /etc/apt/sources.list.d/docker.list | true

sudo apt update
sudo apt install -y curl apt-transport-https gnupg2

if [ ! -f "/etc/apt/sources.list.d/powershell.list" ]; then
 echo \
  "deb [arch=amd64 signed-by=/etc/apt/keyrings/powershell.gpg] https://packages.microsoft.com/ubuntu/${RELEASE}/prod ${CODENAME} main" \
  | sudo tee /etc/apt/sources.list.d/powershell.list > /dev/null
fi

if [ ! -f "/etc/apt/keyrings/powershell.gpg" ]; then
 curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o /etc/apt/keyrings/powershell.gpg
 sudo chmod a+r /etc/apt/keyrings/powershell.gpg
fi

sudo apt-get update
sudo apt install powershell -y
