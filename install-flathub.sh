#!/usr/bin/env bash

set -e -x

sudo add-apt-repository -y ppa:flatpak/stable
sudo apt update
sudo apt install -y flatpak gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
