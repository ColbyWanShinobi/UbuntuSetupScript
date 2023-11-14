#!/usr/bin/env bash

#https://forum.manjaro.org/t/root-tip-how-to-disable-write-cache-for-usb-storage-devices/135566

set -e -x

if [ ! -x "$(command -v hdparm)" ];then
  sudo apt update
  sudo apt install -y hdparm
fi


if [ ! -f "/etc/udev/rules.d/99-usb-sync.rules" ]; then
  #echo ${udev_rule} | sudo tee /etc/udev/rules.d/99-usb-sync.rules
  sudo tee /etc/udev/rules.d/99-usb-sync.rules <<-DELIM
    # rule to disable write cache for usb storage
    # requires hdparm to be installed
    ACTION=="add|change", KERNEL=="sd[a-z]", ENV{ID_USB_TYPE}=="disk", RUN+="/usr/bin/hdparm -W 0 /dev/%K"

    # the following rules are introduced with kernel 6.2
    # https://docs.kernel.org/admin-guide/abi-testing.html#abi-sys-class-bdi-bdi-strict-limit
    # https://docs.kernel.org/admin-guide/abi-testing.html#abi-sys-class-bdi-bdi-max-ratio
    # https://docs.kernel.org/admin-guide/abi-testing.html#abi-sys-class-bdi-bdi-max-bytes
    ACTION=="add|change", KERNEL=="sd[a-z]", ENV{ID_USB_TYPE}=="disk", RUN+="/usr/bin/udev-usb-sync %k"
DELIM
fi

if [ ! -f "/usr/bin/udev-usb-sync" ]; then
  #echo ${udev_script} | sudo tee /usr/bin/udev-usb-sync
  sudo tee /usr/bin/udev-usb-sync <<-DELIM
    # script to tweak USB storage device filesystem sync
    #
    # sources /etc/usb-dev-sync/usb-dev-sync.conf
    #

    use_tweaks=1
    max_bytes=16777216
    max_ratio=50
    strict_limit=1

    # read user config
    #source /etc/udev-usb-sync/udev-usb-sync.conf

    if [[ "$use_tweaks" = 0 ]]; then
            exit 0
    fi

    if [[ -z "$1" ]]; then
            exit 1
    fi

    echo "$max_bytes" > "/sys/block/$1/bdi/max_bytes"
    echo "$max_ratio" > "/sys/block/$1/bdi/max_ratio"
    echo "$strict_limit" > "/sys/block/$1/bdi/strict_limit"
DELIM
  sudo chmod +x /usr/bin/udev-usb-sync
fi

sudo udevadm control --reload
