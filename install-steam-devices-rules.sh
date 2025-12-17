#!/bin/bash

# Copy the udev rules file
sudo cp ./etc/udev/rules.d/60-steam-input.rules /etc/udev/rules.d/
sudo cp ./etc/udev/rules.d/60-steam-vr.rules /etc/udev/rules.d/
sudo cp ./etc/udev/rules.d/40-starcitizen-joystick-uaccess.rules /etc/udev/rules.d/

ls -alh /etc/udev/rules.d/

# Reboot the system
#echo "Rebooting the system to apply changes..."
#sudo reboot
