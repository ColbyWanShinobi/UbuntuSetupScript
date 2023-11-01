#!/usr/bin/env bash

set -e -x

#Install Terraform
if [ ! -f "/usr/share/keyrings/hashicorp-archive-keyring.gpg" ]; then
  wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
fi

if [ ! -f "/etc/apt/sources.list.d/hashicorp.list" ]; then
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
fi

if [ ! -x "$(command -v terraform)" ];then
  sudo apt update && sudo apt install terraform
fi
