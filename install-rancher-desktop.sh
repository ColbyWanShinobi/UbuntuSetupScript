#!/usr/bin/env bash

set -e
#set -x

req_packages=("gnupg2" "pass" "curl" "ca-certificates" "gpg" "pass" "qemu-kvm")  # Let's check to see if my required packages are installed

apt_updated=false

for pkg in "${req_packages[@]}"; do
  if dpkg -s "$pkg" >/dev/null 2>&1; then
    echo "$pkg is installed"
  else
    echo "$pkg is not installed. Installing pre-reqs..."
    if ! $apt_updated; then
      sudo apt update
      apt_updated=true
    fi
    sudo apt install -y "$pkg"
  fi
done

#Check for privileges to /dev/kvm
if [ -r /dev/kvm ] && [ -w /dev/kvm ]; then
    :
else
    sudo usermod -a -G kvm "$USER"
    newgrp kvm
    echo 'Insufficient privileges to /dev/kvm. You've been added to the kvm group'
fi

# Get the key ID of the last generated key
gpg_key_id=$(gpg --list-secret-keys --with-colons ${USER}@$(hostname) | awk -F: '/sec:/ {print $5}')

# If there's no key, generate a new one
if [ -z "$gpg_key_id" ]; then
  echo "No GPG key found. Generating a new one..."

  # Get real username from the current logged in account
  real_user_name=$(getent passwd $USER | cut -d ':' -f 5 | cut -d ',' -f 1)
  hostname=$(hostname)

  #Generate gpg key
  gpg --batch --generate-key <<EOF
Key-Type: 1
Key-Length: 2048
Subkey-Type: 1
Subkey-Length: 2048
Name-Real: ${real_user_name}
Name-Comment: Your Comment
Name-Email: ${USER}@${hostname}
Expire-Date: 0
%no-protection
%commit
EOF

  # Get the key ID of the last generated key
  gpg_key_id=$(gpg --list-secret-keys --with-colons ${USER}@$(hostname) | awk -F: '/uid:/ {print $5}')
fi

pass init ${gpg_key_id}

sudo install -m 0755 -d /etc/apt/keyrings

if [ ! -f "/etc/apt/keyrings/isv-rancher-stable-archive-keyring.gpg" ]; then
 curl -fsSL https://download.opensuse.org/repositories/isv:/Rancher:/stable/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/isv-rancher-stable-archive-keyring.gpg
 sudo chmod a+r /etc/apt/keyrings/isv-rancher-stable-archive-keyring.gpg
fi

CODENAME=$(grep CODENAME /etc/os-release | cut -d'=' -f2)
if [ ! -f "/etc/apt/sources.list.d/isv-rancher-stable.list" ]; then
 echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.opensuse.org/repositories/isv:/Rancher:/stable/deb \
  "${CODENAME}" stable" | \
  sudo tee /etc/apt/sources.list.d/isv-rancher-stable.list > /dev/null
fi

sudo apt install -y rancher-desktop
