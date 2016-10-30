#!/bin/sh

# Get device codename and save it to a file
adb start-server
echo "Please plug in your phone through usb to continue, the script will start automatic."
adb 'wait-for-device'
adb shell "getprop ro.product.device" > ${PWD}/device.txt
device=`tr -d '\r' < device.txt`

# Creating Directories
mkdir ${PWD}/devices/$device
mkdir ${PWD}/devices/$device/data
mkdir ${PWD}/devices/$device/bootimage

# Pulling info from device
adb shell "ls /dev" >${PWD}/devices/$device/data/dev
adb shell "ls /dev/input" >${PWD}/devices/$device/data/input
adb shell "ls /dev/graphic" >${PWD}/devices/$device/data/graphic
adb shell "ls /dev/graphics" >${PWD}/devices/$device/data/graphics

# Checking the Debian.tar.gz on faults
echo "Checking if the debian.tar.gz is corrupt or not"
gunzip -t ${PWD}/files/debian/*.tar.gz > /dev/null 2>&1 
if [ "$?" = "1" ]; then
	echo "File is corrupt, aborting"
	exit
else
	echo "File is not corrupt"
fi

# Copying Debian system and extracting it
echo "Extracting Debian system, this can take a while depending on your computer."
tar -xvf ${PWD}/files/debian/*.tar.gz -C ${PWD}/devices/$device/ > /dev/null 2>&1  || true
mv ${PWD}/devices/$device/20151106 ${PWD}/devices/$device/sdcard

# Creating some variables
graphic=`tr -d '\r' < ${PWD}/devices/$device/data/graphic`
graphics=`tr -d '\r' < ${PWD}/devices/$device/data/graphics`

# Echo some info
echo "Make sure this info is correct before proceeding to the next step."
echo "Codename: $device"

# Make a "/dev/graphic(s) No such file or directory" check
if [ "$graphics" = "/dev/graphics: No such file or directory" -a "$graphic" = "/dev/graphic: No such file or directory" ]; then
	echo "No Framebuffer found, aborting"
	exit
else if [ "$graphic" = "/dev/graphic: No such file or directory" ]; then
	 	echo "Framebuffer: $graphics"
else if [ "$graphics" = "/dev/graphics: No such file or directory" ]; then
 			echo "Framebuffer: $graphics"
		
		fi
	fi
fi


# Done
echo "Done with setting up, make sure to place your Cyanogenmod boot.img in ${PWD}/devices/$device/bootimage"


