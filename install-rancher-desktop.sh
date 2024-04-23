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
  echo 'Insufficient privileges to /dev/kvm. You have been added to the kvm group'
fi

# Get the key ID of the last generated key
gpg_key_id=$(gpg --list-secret-keys --with-colons ${USER}@$(hostname) | grep -o -E '[0-9]{6,}' | head -1)

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
  gpg_key_id=$(gpg --list-secret-keys --with-colons ${USER}@$(hostname) | grep -o -E '[0-9]{6,}' | head -1)
fi

pass init ${gpg_key_id}

sudo install -m 0755 -d /etc/apt/keyrings

sudo rm -fv /etc/apt/keyrings/isv-rancher-stable-archive-keyring.gpg

if [ ! -f "/etc/apt/keyrings/isv-rancher-stable-archive-keyring.gpg" ]; then
  curl -s https://download.opensuse.org/repositories/isv:/Rancher:/stable/deb/Release.key | gpg --dearmor | sudo dd status=none of=/etc/apt/keyrings/isv-rancher-stable-archive-keyring.gpg
  sudo chmod a+r /etc/apt/keyrings/isv-rancher-stable-archive-keyring.gpg
fi

sudo rm -fv /etc/apt/sources.list.d/isv-rancher-stable.list

CODENAME=$(grep CODENAME /etc/os-release | cut -d'=' -f2 | head -1)
if [ ! -f "/etc/apt/sources.list.d/isv-rancher-stable.list" ]; then
  echo 'deb [signed-by=/etc/apt/keyrings/isv-rancher-stable-archive-keyring.gpg] https://download.opensuse.org/repositories/isv:/Rancher:/stable/deb/ ./' | sudo dd status=none of=/etc/apt/sources.list.d/isv-rancher-stable.list
fi

sudo apt update -y
sudo apt install -y rancher-desktop
