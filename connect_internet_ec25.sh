#!/bin/bash
# Run the commands with root privileges using sudo

# Function to check if interface is available
sudo -i <<EOF
cd /sys/class/gpio || exit

#Start enable power for miniPCIe slot#
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

#Enable power for miniPCIe slot end#

#Check WWAN0 interface to be ready before start dialing process#
interface="wwan0"

#Checking WWAN0 interface function#
check_interface() {
    if [[ "$(ip link show $interface 2>/dev/null)" ]]; then
        return 0  # Interface is available
    else
        return 1  # Interface is not available
    fi
}

#Call checking WWAN0 interface function#
while :
do
    if check_interface; then
        echo "Interface $interface is available. Continuing with the script." #If wwan0 interface is ready. Go to next step
        break
    else
        echo "Interface $interface is not available. Waiting..." #If wwan0 interface is not ready. Waiting for ... seconds before try again
        sleep 5  # Adjust the interval between checks (in seconds)
    fi
done

#Waiting for 20 seconds for ec25 cellular module initialization#
echo 
echo 
echo Waiting for 20 seconds before start dialing
sleep 20

#Go to dialing script location#
cd /
cd /usr/local/bin/ec25_cellular_module/linux-ppp-scripts

#Start dialing#
echo 
echo 
echo "Start dialing..."
echo 
echo 
# Run the script in the background to capture its output    
sudo ./quectel-pppd.sh > output.log &

# Monitor the output for a specific message using grep
while :
do
    if grep -q "IPV6CP: timeout sending Config-Requests" output.log; then
        echo 
        echo "Dialing completed. Process next step"
        echo 
        pkill -INT -f "quectel-pppd.sh"
        sleep 2  #Wait for 2 seconds before running the next command
        #Add new default gateway route for internet connection from ec25 4g module
        sudo route add default gw 10.64.64.64
        echo
        echo "Cellular connection is now ready to use"
        break  # Exit the loop
    fi
    sleep 1  # Check debug message from dialing script every second
done

exit
EOF
