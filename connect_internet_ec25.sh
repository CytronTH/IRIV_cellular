#!/bin/bash

# Run the commands with root privileges using sudo
sudo -i <<EOF
cd /sys/class/gpio || exit

# Export GPIO pins 6 and 5
echo 6 > export
echo 5 > export

# Configure GPIO pin 6
cd gpio6 || exit
echo out > direction
echo 1 > value

# Configure GPIO pin 5
cd ..
cd gpio5 || exit
echo out > direction
echo 1 > value

cd /

cd /usr/local/bin/ec25_cellular_module/linux-ppp-scripts

sudo ./quectel-pppd.sh

echo "Waiting for dailing..."
sleep 20  # This will pause the script for 20 seconds
echo "Dailing done"

sudo add default gw 10.10.10.64

echo "Cellular connection is now ready to use"

exit
EOF
