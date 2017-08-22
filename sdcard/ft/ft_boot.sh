#!/bin/sh

echo "Starting Custom Tool......"

## Mounting point
mmc_device=""
if [ -b /dev/mmcblk0p1 ];then
    mmc_device=/dev/mmcblk0p1
elif [ -b /dev/mmcblk0 ];then
    mmc_device=/dev/mmcblk0
fi
sd_mountdir=/tmp/sd


if [ "$mmc_device" == "" ];then
	echo "Impossible to find sdcard mounting point.Abort"
	exit
fi

## Mount sdcard
mkdir $sd_mountdir
mount -t vfat $mmc_device $sd_mountdir
if [ $? -ne 0 ];then
	echo "Error mounting sdcard.Abort"
	exit
fi

## Execute custom code
if [ ! -f $sd_mountdir/valhalla.sh ];then
    echo "Error starting valhalla.sh under sdcard root.Abort"
	exit
fi

. $sd_mountdir/valhalla.sh

echo "Custom Tool......finished"
