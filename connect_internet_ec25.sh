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

echo "Waiting for dialing..."
# Run the script in the background to capture its output
sudo ./quectel-pppd.sh > output.log &

# Monitor the output for a specific message using grep
while :
do
    if grep -q "IPV6CP: timeout sending Config-Requests" output.log; then
        echo "Detected specific sentence. Proceeding with the next command."
        # Perform the next action or command here
        # For example, toggle Ctrl+C and run the next command
        # (replace the sleep with your actual command)
        pkill -INT -f "quectel-pppd.sh"
        sleep 2  # Example: wait for 2 seconds before running the next command
        # Run the next command here
        sudo route add default gw 10.64.64.64
        echo "Cellular connection is now ready to use"
        break  # Exit the loop
    fi
    sleep 1  # Check every second
done

exit
EOF
