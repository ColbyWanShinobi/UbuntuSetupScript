#!/usr/bin/env bash

set -e -x

# List of required command-line utilities to run this script
prereq_list=(curl gpg)

# Check to see if the prereq utilities are installed
for util in "${prereq_list[@]}";do
  if [ ! -x "$(command -v ${util})" ];then
    echo "Missing utility! Please install [${util}] and try again..."
    exit 1
  fi
done

if [ ! -f "/etc/apt/keyrings/githubcli-archive-keyring.gpg" ]; then
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/githubcli-archive-keyring.gpg
  sudo chmod a+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
fi

if [ ! -f "/etc/apt/sources.list.d/github-cli.list" ]; then
 echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | \
  sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
fi

sudo apt-get update
sudo apt-get install -y gh
