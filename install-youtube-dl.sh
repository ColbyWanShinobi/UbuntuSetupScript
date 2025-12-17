#!/usr/bin/env bash

set -e -x

#Install YouTube Download
if [ ! -x "$(command -v yt-dlp)" ];then
  mkdir -p ${HOME}/.local/bin
  wget https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -O ${HOME}/.local/bin/yt-dlp
  chmod a+rx ${HOME}/.local/bin/yt-dlp  # Make executable
fi
sudo apt install -y ffmpeg
