#!/bin/bash

# Make sure the script is run as root.
if [ $(id -u) -ne 0 ]; then
    echo
    echo
    echo "Please run as root."
    exit 1
fi


# create folder for scripts.
cd /usr/local/bin
sudo mkdir ec25_cellular_module
cd ec25_cellular_module

git clone https://github.com/turmary/linux-ppp-scripts.git
