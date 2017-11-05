#!/bin/sh
 
sd_mountdir=/tmp/sd
LOGFILE="log-otaValhalla.log"
/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "Injector"  |  /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "----------------------------------------------------"  |  /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota

/tmp/ld-uClibc.so.0 /tmp/busybox sync

/tmp/ld-uClibc.so.0 /tmp/busybox mkdir /tmp/Key
pathDest=/tmp/Key
flagUnmount=0


/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "\n /proc/mtd"  |  /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "----------------------------------------------------"  |  /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
/tmp/ld-uClibc.so.0 /tmp/busybox cat /proc/mtd  |  /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota

psRTSP_Server=/tmp/ld-uClibc.so.0 /tmp/busybox ps -o pid,args -C bash | /tmp/ld-uClibc.so.0 /tmp/busybox awk '/rtsp_basic/ { print $1 }'
kill -9 $psRTSP_Server | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota 

/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "\n mount"  |  /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "----------------------------------------------------"  |  /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
/tmp/ld-uClibc.so.0 /tmp/busybox mount |  /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota


/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "\n lsof /mnt/data" |  /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "----------------------------------------------------"  |  /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
/tmp/ld-uClibc.so.0 /tmp/busybox lsof | /tmp/ld-uClibc.so.0 /tmp/busybox grep '/mnt/data' | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota

cd /

## Clean Process underr /mnt/data/
/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "lsof"  /tmp/ld-uClibc.so.0 | /tmp/busybox logger -t miio_ota
/tmp/ld-uClibc.so.0 /tmp/busybox lsof | /tmp/ld-uClibc.so.0 /tmp/busybox grep /mnt/data | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota	
/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "\nLsof only pid\n"  | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota	
/tmp/ld-uClibc.so.0 /tmp/busybox lsof | /tmp/ld-uClibc.so.0 /tmp/busybox grep /mnt/data  | /tmp/ld-uClibc.so.0 /tmp/busybox awk '{print $1}' | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "\n#KILL#\n" | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota	
/tmp/ld-uClibc.so.0 /tmp/busybox kill -9 $(/tmp/ld-uClibc.so.0 /tmp/busybox lsof | /tmp/ld-uClibc.so.0 /tmp/busybox grep /mnt/data  | /tmp/ld-uClibc.so.0 /tmp/busybox awk '{print $1}') | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "\nlsof\n" | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "----------------------------------------------------" | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
/tmp/ld-uClibc.so.0 /tmp/busybox lsof | /tmp/ld-uClibc.so.0 /tmp/busybox grep /mnt/data | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "\n#@@#\n" | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota


/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "\n umount /dev/mtdblock3"  | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "----------------------------------------------------"  | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
/tmp/ld-uClibc.so.0 /tmp/busybox umount /mnt/data | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
if [ $? -ne 0 ];then
	 /tmp/ld-uClibc.so.0 /tmp/busybox echo -e "umount /dev/mtdblock3  FAILED" | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota	
	return -1
fi
	

/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "\n mount $pathDest" | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "----------------------------------------------------"  | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
/tmp/ld-uClibc.so.0 /tmp/busybox mount -o ro -t jffs2 /dev/mtdblock3 $pathDest  | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
/tmp/ld-uClibc.so.0 /tmp/busybox umount $pathDest  | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
/tmp/ld-uClibc.so.0 /tmp/busybox mount -o rw -t jffs2 /dev/mtdblock3 $pathDest  | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
if [ $? -ne 0 ];then
	/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "mount /dev/mtdblock3  FAILED" | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota	
	/tmp/ld-uClibc.so.0 /tmp/busybox umount /mnt/media/mmcblk0p1
	/tmp/ld-uClibc.so.0 /tmp/busybox umount /mnt/media/mmcblk0
	/tmp/ld-uClibc.so.0 /tmp/busybox sync
	/tmp/ld-uClibc.so.0 /tmp/busybox reboot
fi


/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "after mount..." | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
/tmp/ld-uClibc.so.0 /tmp/busybox echo -e " "
/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "mount" | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "----------------------------------------------------"  | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
/tmp/ld-uClibc.so.0 /tmp/busybox mount | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "\nListing FT"  | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "----------------------------------------------------"  | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
/tmp/ld-uClibc.so.0 /tmp/busybox ls -al $pathDest/ft | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota

if [ -d $pathDest/ft ];then
	/tmp/ld-uClibc.so.0 /tmp/busybox cat $pathDest/ft/prikey.pem | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota	
	/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "\ncp $sd_mountdir/tools/prikey.pem $pathDest/ft/prikey.pem "   | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota		
	/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "----------------------------------------------------"   | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota	
	/tmp/ld-uClibc.so.0 /tmp/busybox cp $sd_mountdir/tools/prikey.pem $pathDest/ft/prikey.pem | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota	
	/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "Before copying...done" | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
	/tmp/ld-uClibc.so.0 /tmp/busybox cat $pathDest/ft/prikey.pem | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
	
	/tmp/ld-uClibc.so.0 /tmp/busybox cp $sd_mountdir/tools/ft.zip $pathDest/ft/
	/tmp/ld-uClibc.so.0 /tmp/busybox mv $sd_mountdir/ft $sd_mountdir/ft_bck  
	
else
	/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "Error $pathDest/ft doesnt exist"  | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota	
fi


/tmp/ld-uClibc.so.0 /tmp/busybox umount /mnt/media/mmcblk0p1
/tmp/ld-uClibc.so.0 /tmp/busybox umount /mnt/media/mmcblk0
/tmp/ld-uClibc.so.0 /tmp/busybox sync
/tmp/ld-uClibc.so.0 /tmp/busybox reboot

return 0