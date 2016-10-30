#!/bin/sh
device=`tr -d '\r' < device.txt`
mkdir ${PWD}/out
mkdir ${PWD}/out/$device/
mkdir ${PWD}/out/$device/source
mkdir ${PWD}/out/$device/compiled/
cp ${PWD}/devices/$device/bootimage/boot.img ${PWD}/out/$device/source/boot.img
./tools/bootimage/unmkbootimg ${PWD}/out/$device/source/boot.img
./tools/bootimage/unpack-bootimg.pl ${PWD}/out/$device/source/boot.img
rm -rf ${PWD}/out/$device/source/boot.img-ramdisk/*

# Creating Ramdisk folders
mkdir ${PWD}/out/$device/source/boot.img-ramdisk/data
mkdir ${PWD}/out/$device/source/boot.img-ramdisk/dev
mkdir ${PWD}/out/$device/source/boot.img-ramdisk/mnt
mkdir ${PWD}/out/$device/source/boot.img-ramdisk/proc
mkdir ${PWD}/out/$device/source/boot.img-ramdisk/sbin
mkdir ${PWD}/out/$device/source/boot.img-ramdisk/sys
mkdir ${PWD}/out/$device/source/boot.img-ramdisk/system
mkdir ${PWD}/out/$device/source/boot.img-ramdisk/mnt/root

# Copying ramdisk files
cp ${PWD}/files/ramdisk/init ${PWD}/out/$device/source/boot.img-ramdisk/init
cp ${PWD}/files/ramdisk/sbin/busybox ${PWD}/out/$device/source/boot.img-ramdisk/sbin/busybox

# Setting permissions
chmod a+x ${PWD}/files/ramdisk/init ${PWD}/out/$device/source/boot.img-ramdisk/init
chmod a+x ${PWD}/files/ramdisk/sbin/busybox ${PWD}/out/$device/source/boot.img-ramdisk/sbin/busybox

# Recompiling the Ramdisk
rm -rf ${PWD}/out/$device/source/boot.img-ramdisk.cpio.gz
 
cd ${PWD}/out/$device/source/boot.img-ramdisk
find . | cpio --quiet -H newc -o | gzip > ../initramfs.cpio.gz
cd ../../../../

# Compile the boot.img
rm ${PWD}/initramfs.cpio.gz
mv ${PWD}/zImage ${PWD}/out/$device/source/zImage
cp ${PWD}/tools/bootimage/mkbootimg ${PWD}/out/$device/source/
cd ${PWD}/out/$device/source/
./mkbootimg --kernel zImage --ramdisk initramfs.cpio.gz --base 0x0 --cmdline 'console=ttyS1,115200n8 androidboot.selinux=permissive' -o new_boot.img
echo "Kernel compiled"
cd ../../../

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
tar -xvf ${PWD}/files/debian/*.tar.gz -C ${PWD}/out/$device/ > /dev/null 2>&1  || true
mv ${PWD}/out/$device/20151106 ${PWD}/out/$device/compiled/sdcard

# Adding patched chroot file to chroot
echo "Added patched init.stage2 file to your chroot."
rm ${PWD}/out/$device/compiled/sdcard/etc/init.stage2
cp -f ${PWD}/devices/$device/patches/init.stage2 ${PWD}/out/$device/compiled/sdcard/etc/init.stage2

# Copy kernel to compiled folder
echo "Copying kernel"
cp ${PWD}/out/$device/source/new_boot.img ${PWD}/out/$device/compiled/boot.img

# Done
echo "Done!"

