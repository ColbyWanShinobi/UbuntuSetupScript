#!/usr/bin/env bash

set -e
set -x

commands=("gdebi" "wget")
declare -a missing_commands

for cmd in "${commands[@]}"; do
    if ! command -v $cmd > /dev/null; then
        echo "$cmd not found, will be installed..."
        missing_commands+=($cmd)
    fi
done

if [ ${#missing_commands[@]} -ne 0 ]; then
    echo "Updating package lists..."
    sudo apt update
    for cmd in "${missing_commands[@]}"; do
        echo "Installing $cmd..."
        sudo apt install -y $cmd
    done
fi

DIVE_VERSION=$(curl -sL "https://api.github.com/repos/wagoodman/dive/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
wget https://github.com/wagoodman/dive/releases/download/v${DIVE_VERSION}/dive_${DIVE_VERSION}_linux_amd64.deb -O ${HOME}/Downloads/dive_${DIVE_VERSION}_linux_amd64.deb
sudo gdebi ${HOME}/Downloads/dive_${DIVE_VERSION}_linux_amd64.deb
