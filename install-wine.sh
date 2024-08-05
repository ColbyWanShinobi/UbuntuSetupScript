#!/usr/bin/env bash

set -e -x

#Install Wine
sudo apt update
sudo dpkg --add-architecture i386
sudo apt install -y wine64 wine32 libasound2-plugins:i386 libsdl2-2.0-0:i386 libdbus-1-3:i386 libsqlite3-0:i386
