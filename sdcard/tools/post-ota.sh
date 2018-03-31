#!/bin/sh
export LD_LIBRARY_PATH=/tmp

/tmp/ld-uClibc.so.0 /tmp/busybox echo "Calling Inject....." | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
/tmp/ld-uClibc.so.0 /tmp/busybox sh /tmp/inject.sh


/tmp/ld-uClibc.so.0 /tmp/busybox echo "OTA: copy log to TF." | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota

/tmp/ld-uClibc.so.0 /tmp/busybox sh /mnt/data/miot/logtf.sh OTA
#/tmp/ld-uClibc.so.0 /tmp/busybox sh /mnt/data/miot/logmi.sh

/tmp/ld-uClibc.so.0 /tmp/busybox echo "OTA: about to reboot." | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota

#/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "Content /etc/init.d/rcK\n" | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
#/tmp/ld-uClibc.so.0 /tmp/busybox cat /etc/init.d/rcK | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota




/tmp/ld-uClibc.so.0 /tmp/busybox umount /mnt/media/mmcblk0p1
/tmp/ld-uClibc.so.0 /tmp/busybox umount /mnt/media/mmcblk0
/tmp/ld-uClibc.so.0 /tmp/busybox sync

/tmp/ld-uClibc.so.0 /tmp/busybox reboot