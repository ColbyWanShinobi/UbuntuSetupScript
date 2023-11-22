#!/usr/bin/env bash

set -e -x

sudo apt update
sudo apt install -y qemu-kvm qemu-utils libvirt-daemon-system libvirt-clients bridge-utils virt-manager ovmf

sudo systemctl enable --now libvirtd

sudo virsh net-start default
sudo virsh net-autostart default

usermod -aG kvm,input,libvirt ${USER}
newgrp kvm
newgrp input
newgrp libvirt
