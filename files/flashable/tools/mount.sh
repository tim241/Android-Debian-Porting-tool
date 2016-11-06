#!/bin/sh
mount -o remount,rw /
mkdir /tmp/linux_chroot/
su -C mount -t ext4 /dev/block/mmcblk1p2 /tmp/linux_chroot/
