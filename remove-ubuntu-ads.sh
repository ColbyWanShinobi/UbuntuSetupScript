#!/usr/bin/env bash

set -e -x

TIMESTAMP=$(date +%s)

sudo mv -v /etc/apt/apt.conf.d/20apt-esm-hook.conf /etc/apt/apt.conf.d/20apt-esm-hook.conf.${TIMESTAMP}.bak
sudo touch /etc/apt/apt.conf.d/20apt-esm-hook.conf
