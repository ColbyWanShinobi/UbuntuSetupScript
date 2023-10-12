#!/usr/bin/env bash

set -e -x

#Download a bunch of git repos for later
if [ ! -d "${HOME}/git/public/obs-gstreamer" ]; then
  git clone https://github.com/fzwoch/obs-gstreamer.git ${HOME}/git/public/obs-gstreamer
  #sudo cp ${HOME}/Downloads/obs-gstreamer/linux/obs-gstreamer.so /usr/lib/x86_64-linux-gnu/obs-plugins/
  #sudo apt install cmake libobs-dev libvulkan-dev libgl-dev libx11-dev libxcb1-dev libwayland-client++0
fi

if [ ! -d "${HOME}/git/public/Complete-Single-GPU-Passthrough" ]; then
  git clone https://github.com/QaidVoid/Complete-Single-GPU-Passthrough.git ${HOME}/git/public/Complete-Single-GPU-Passthrough
fi

if [ ! -d "${HOME}/git/public/OSX-KVM" ]; then
  git clone https://github.com/kholia/OSX-KVM.git ${HOME}/git/public/OSX-KVM
fi

if [ ! -d "${HOME}/git/public/macOS-Simple-KVM" ]; then
  git clone https://github.com/foxlet/macOS-Simple-KVM.git ${HOME}/git/public/macOS-Simple-KVM
fi

if [ ! -d "${HOME}/git/public/obs-pipewire-audio-capture" ]; then
  #https://ubuntuhandbook.org/index.php/2022/04/pipewire-replace-pulseaudio-ubuntu-2204/
  git clone https://github.com/dimtpap/obs-pipewire-audio-capture.git ${HOME}/git/public/obs-pipewire-audio-capture
fi

if [ ! -d "${HOME}/git/public/linux-apfs-rw" ]; then
  git clone https://github.com/linux-apfs/linux-apfs-rw.git ${HOME}/git/public/linux-apfs-rw
fi

if [ ! -d "${HOME}/git/public/lug-helper" ]; then
  git clone https://github.com/starcitizen-lug/lug-helper.git ${HOME}/git/public/lug-helper
fi
