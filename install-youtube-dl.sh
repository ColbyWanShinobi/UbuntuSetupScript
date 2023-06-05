#!/usr/bin/env bash

set -e -x

#Install YouTube Download
if [ ! -x "$(command -v yt-dlp)" ];then
  sudo wget https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -O /usr/local/bin/yt-dlp
  sudo chmod a+rx /usr/local/bin/yt-dlp  # Make executable
  sudo apt install -y ffmpeg
fi