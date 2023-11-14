#!/usr/bin/env bash

#set -e -x

#
if [[ ${XDG_CURRENT_DESKTOP} == "ubuntu:GNOME" || ${XDG_CURRENT_DESKTOP} == "Unity" ]];then
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
  https://extensions.gnome.org/extension/4862/bat_consumption_wattmeter/
  https://extensions.gnome.org/extension/904/disconnect-wifi/
  https://extensions.gnome.org/extension/750/openweather/
  https://extensions.gnome.org/extension/1112/screenshot-tool/
  https://extensions.gnome.org/extension/906/sound-output-device-chooser/
  https://extensions.gnome.org/extension/988/harddisk-led/
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
  sudo apt update
  sudo apt install -y gnome-tweaks gnome-shell-extension-manager chrome-gnome-shell
fi
