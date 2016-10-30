#!/bin/sh
device=`tr -d '\r' < device.txt`
mkdir ${PWD}/out
mkdir ${PWD}/out/$device/
mkdir ${PWD}/out/$device/source
cp ${PWD}/devices/$device/bootimage/boot.img ${PWD}/out/$device/source/boot.img
./tools/bootimage/unmkbootimg ${PWD}/out/$device/source/boot.img
./tools/bootimage/unpack-bootimg.pl ${PWD}/out/$device/source/boot.img
rm -rf ${PWD}/out/$device/source/boot.img-ramdisk/*

# Creating Ramdisk folders
mkdir ${PWD}/out/$device/compiled
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
cp ${PWD}/zImage ${PWD}/out/$device/source/zImage
cp ${PWD}/tools/bootimage/mkbootimg ${PWD}/out/$device/source/
cd ${PWD}/out/$device/source/
./mkbootimg --kernel zImage --ramdisk initramfs.cpio.gz --base 0x0 --cmdline 'console=ttyS1,115200n8 androidboot.selinux=permissive' -o new_boot.img
