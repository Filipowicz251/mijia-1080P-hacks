#!/bin/sh
 

export LD_LIBRARY_PATH=/tmp

/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "OTA: copy log to TF." | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota

/tmp/ld-uClibc.so.0 /tmp/busybox sh /mnt/data/miot/logtf.sh OTA
#/tmp/ld-uClibc.so.0 /tmp/busybox sh /mnt/data/miot/logmi.sh

/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "Valhalla Restoring Key" | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota

sd_mountdir=/tmp/sd
LOGFILE="log-otaValhalla--.log"
/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "Calling Inject"   | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "----------------------------------------------------"   | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota

if [ ! -f /tmp/inject.sh ];then
   /tmp/ld-uClibc.so.0 /tmp/busybox echo -e " Inject /tmp/inject.sh doesn´t exist" | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
   $sd_mountdir/tools/inject.sh
else
    /tmp/ld-uClibc.so.0 /tmp/busybox echo -e " Inject /tmp/inject.sh exist" | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
	/tmp/inject.sh
fi 

if [ $? -eq 0 ];then
	/tmp/ld-uClibc.so.0 /tmp/busybox echo -e " Inject Success" | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota # Actually this can never happen because the original binary should ve killed.
else
	/tmp/ld-uClibc.so.0 /tmp/busybox echo -e " Inject Failed" | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
fi

/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "OTA: about to reboot......" | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota


/tmp/ld-uClibc.so.0 /tmp/busybox umount /mnt/media/mmcblk0p1
/tmp/ld-uClibc.so.0 /tmp/busybox umount /mnt/media/mmcblk0
/tmp/ld-uClibc.so.0 /tmp/busybox sync
/tmp/ld-uClibc.so.0 /tmp/busybox reboot
