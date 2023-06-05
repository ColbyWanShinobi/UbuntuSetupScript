#!/usr/bin/env bash

set -e -x

#Apple Fonts
#https://invent.kde.org/plasma/plasma-desktop/-/issues/5
if [ ! -d "${HOME}/git/public/apple-emoji-linux" ]; then
  sudo mkdir -p /usr/share/fonts/truetype/apple-emoji-linux/
  git clone https://github.com/samuelngs/apple-emoji-linux.git ${HOME}/git/public/apple-emoji-linux
  wget https://github.com/samuelngs/apple-emoji-linux/releases/download/ios-15.4/AppleColorEmoji.ttf -O ${HOME}/Downloads/AppleColorEmoji.ttf
  sudo cp ${HOME}/Downloads/AppleColorEmoji.ttf /usr/share/fonts/truetype/apple-emoji-linux/
fi
if [ ! -d "${HOME}/git/public/sfwin" ]; then
  git clone https://github.com/aishalih/sfwin.git ${HOME}/git/public/sfwin
  sudo mkdir -p /usr/share/fonts/opentype/sfwin/
  find ${HOME}/git/public/sfwin -name \*.otf -exec sudo cp -v {} /usr/share/fonts/opentype/sfwin/ \;
  sudo fc-cache -f -v
fi