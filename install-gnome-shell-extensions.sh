#!/usr/bin/env bash

set -e -x

#Create local folders
mkdir -p ${HOME}/bin
mkdir -p ${HOME}/git/personal
mkdir -p ${HOME}/git/public

#
if [ ${XDG_CURRENT_DESKTOP} == "ubuntu:GNOME" ];then
  #gsettings set org.gnome.shell.extensions.dash-to-dock show-apps-at-top true
  #gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
  #gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

  array=(
  https://extensions.gnome.org/extension/5489/search-light/
  https://extensions.gnome.org/extension/1460/vitals/
  https://extensions.gnome.org/extension/1262/bing-wallpaper-changer/
  https://extensions.gnome.org/extension/2/move-clock/
  https://extensions.gnome.org/extension/4651/notification-banner-reloaded/
  https://extensions.gnome.org/extension/4548/tactile/
  https://extensions.gnome.org/extension/1162/emoji-selector/
  )

  for i in "${array[@]}"
  do
    EXTENSION_ID=$(curl -s $i | grep -oP 'data-uuid="\K[^"]+')
    VERSION_TAG=$(curl -Lfs "https://extensions.gnome.org/extension-query/?search=$EXTENSION_ID" | jq '.extensions[0] | .shell_version_map | map(.pk) | max')
    wget -O ${EXTENSION_ID}.zip "https://extensions.gnome.org/download-extension/${EXTENSION_ID}.shell-extension.zip?version_tag=$VERSION_TAG"
    gnome-extensions install --force ${EXTENSION_ID}.zip
    if ! gnome-extensions list | grep --quiet ${EXTENSION_ID}; then
      busctl --user call org.gnome.Shell.Extensions /org/gnome/Shell/Extensions org.gnome.Shell.Extensions InstallRemoteExtension s ${EXTENSION_ID}
    fi
    gnome-extensions enable ${EXTENSION_ID}
    rm ${EXTENSION_ID}.zip
  done
  #sudo apt install -y gnome-tweaks gnome-shell-extension-manager chrome-gnome-shell gstreamer1.0-libav gparted
fi
