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

exit
EOF
