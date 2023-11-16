#!/bin/bash

# Make sure the script is run as root.
if [ $(id -u) -ne 0 ]; then
    echo
    echo
    echo "Please run as root."
    exit 1
fi
#Check if the system has Git installed and ready to use.
if ! command -v git &> /dev/null; then
    echo "Git is not installed. Installing Git..."
    sudo apt update
    sudo apt install git -y

    # Check installation success
    if ! command -v git &> /dev/null; then
        echo "Git installation failed. Please check your internet connection or install Git manually."
        exit 1
    else
        echo "Git has been installed successfully!"
    fi
else
    echo "Git is already installed."
fi

cd /
# create folder for scripts.
cd /usr/local/bin
sudo mkdir ec25_cellular_module
cd ec25_cellular_module

#Download script for EC25 dialing process 
git clone https://github.com/turmary/linux-ppp-scripts.git
echo
echo "Prepare linux-ppp-scripts files complete!"

#Download script for enable miniPCIe slot and start dialing process
wget https://raw.githubusercontent.com/CytronTH/IRIV_cellular/main/connect_internet_ec25.sh
sudo chmod +x connect_internet_ec25.sh
echo
echo "Enable mPCIe and prepare dialing scripts files complete!"
