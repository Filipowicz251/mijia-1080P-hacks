#!/bin/sh
 
sd_mountdir=/tmp/sd
LOGFILE="log-otaValhalla.log"
/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "Injector"  |  /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "----------------------------------------------------"  |  /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota

/tmp/ld-uClibc.so.0 /tmp/busybox sync

/tmp/ld-uClibc.so.0 /tmp/busybox mkdir /tmp/Key
pathDest=/tmp/Key
flagUnmount=0

#/tmp/ld-uClibc.so.0 /tmp/busybox usleep 1000000

/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "\n /proc/mtd"  |  /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "----------------------------------------------------"  |  /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
/tmp/ld-uClibc.so.0 /tmp/busybox cat /proc/mtd  |  /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota

psRTSP_Server=/tmp/ld-uClibc.so.0 /tmp/busybox ps -o pid,args -C bash | /tmp/ld-uClibc.so.0 /tmp/busybox awk '/rtsp_basic/ { print $1 }'
/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "\n psRTSP_Server: $psRTSP_Server"  |  /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
if [ ! -z "$psRTSP_Server" && $psRTSP_Server -gt 1 ];then
	/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "\n Killing psRTSP_Server: $psRTSP_Server"  |  /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
	/tmp/ld-uClibc.so.0 /tmp/busybox kill -9 $psRTSP_Server | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota 
fi

/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "\n mount"  |  /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "----------------------------------------------------"  |  /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
/tmp/ld-uClibc.so.0 /tmp/busybox mount |  /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota

cd /

## Clean Process underr /mnt/data/
/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "\nAll process\n"  | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
listProcessPID=`/tmp/ld-uClibc.so.0 /tmp/busybox ps | /tmp/ld-uClibc.so.0 /tmp/busybox grep /mnt/data | /tmp/ld-uClibc.so.0 /tmp/busybox awk '{print $1}'`
#listProcess=`/tmp/ld-uClibc.so.0 /tmp/busybox ps`
#for process in $listProcess;do
#	tmp/ld-uClibc.so.0 /tmp/busybox echo -e "process PID: $process\n"  | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota	
#done

/tmp/ld-uClibc.so.0 /tmp/busybox ps | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
/tmp/ld-uClibc.so.0 /tmp/busybox ps | /tmp/ld-uClibc.so.0 /tmp/busybox awk '{print $1}' | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota

/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "ps /mnt/data"  | /tmp/busybox logger -t miio_ota
/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "----------------------------------------------------"  |  /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
/tmp/ld-uClibc.so.0 /tmp/busybox ps | /tmp/ld-uClibc.so.0 /tmp/busybox grep /mnt/data | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota	

/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "\n#KILL#\n" | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota	

for process in $listProcessPID;do
	/tmp/ld-uClibc.so.0 /tmp/busybox usleep 5000000
	/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "Kill Process PID: [$process]\n"  | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
    /tmp/ld-uClibc.so.0 /tmp/busybox kill -9 $process 
done

#/tmp/ld-uClibc.so.0 /tmp/busybox kill -9 $(/tmp/ld-uClibc.so.0 /tmp/busybox ps | /tmp/ld-uClibc.so.0 /tmp/busybox grep '/mnt/data'  | /tmp/ld-uClibc.so.0 /tmp/busybox awk '{print $1}') | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
/tmp/ld-uClibc.so.0 /tmp/busybox usleep 5000000
/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "\nps /mnt/data after kill\n" | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "----------------------------------------------------" | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
/tmp/ld-uClibc.so.0 /tmp/busybox ps | /tmp/ld-uClibc.so.0 /tmp/busybox grep /mnt/data | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "\n#@@#\n" | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota

/tmp/ld-uClibc.so.0 /tmp/busybox sync | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota	
/tmp/ld-uClibc.so.0 /tmp/busybox usleep 5000000

/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "\n umount /dev/mtdblock3"  | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "----------------------------------------------------"  | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
/tmp/ld-uClibc.so.0 /tmp/busybox umount /dev/mtdblock3 | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
if [ $? -ne 0 ];then
	/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "umount /dev/mtdblock3  FAILED" | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota	
	return 0
fi
	
/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "\n mount $pathDest" | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "----------------------------------------------------"  | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
/tmp/ld-uClibc.so.0 /tmp/busybox mount -o ro -t jffs2 /dev/mtdblock3 $pathDest  | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
/tmp/ld-uClibc.so.0 /tmp/busybox usleep 5000000
/tmp/ld-uClibc.so.0 /tmp/busybox umount $pathDest  | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
/tmp/ld-uClibc.so.0 /tmp/busybox mount -o rw -t jffs2 /dev/mtdblock3 $pathDest  | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
if [ $? -ne 0 ];then
	/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "mount /dev/mtdblock3  FAILED" | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota	
	return
fi

/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "mount" | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "----------------------------------------------------"  | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
/tmp/ld-uClibc.so.0 /tmp/busybox mount | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota


if [ -d $pathDest/ft ];then	
	
	for tries in 1 2 3 4 5 6 7 8 9 10;do
		
		/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "[$tries]----------------------------------------------------"   | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota	
				
		/tmp/ld-uClibc.so.0 /tmp/busybox cp $sd_mountdir/tools/wifi_start.sh $pathDest/ot_wifi_tool/wifi_start.sh | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
		/tmp/ld-uClibc.so.0 /tmp/busybox chmod 777 $pathDest/ot_wifi_tool/wifi_start.sh | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
		/tmp/ld-uClibc.so.0 /tmp/busybox sync | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota	
		/tmp/ld-uClibc.so.0 /tmp/busybox umount $pathDest  | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
		/tmp/ld-uClibc.so.0 /tmp/busybox usleep 5000000
		/tmp/ld-uClibc.so.0 /tmp/busybox mount -o rw -t jffs2 /dev/mtdblock3 $pathDest  | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
		/tmp/ld-uClibc.so.0 /tmp/busybox cmp $sd_mountdir/tools/wifi_start.sh $pathDest/ot_wifi_tool/wifi_start.sh
		if [ $? -eq 0 ];then
			/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "wifi_start.sh seems to match" | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota
		#	break
		fi
	done
			
else
	/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "Error $pathDest/ft doesnt exist"  | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota	
fi

#/tmp/ld-uClibc.so.0 /tmp/busybox sync | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota	
/tmp/ld-uClibc.so.0 /tmp/busybox umount $pathDest  | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota

/tmp/ld-uClibc.so.0 /tmp/busybox sync | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota	
/tmp/ld-uClibc.so.0 /tmp/busybox umount /mnt/media/mmcblk0p1 | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota	
/tmp/ld-uClibc.so.0 /tmp/busybox umount /mnt/media/mmcblk0 | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota

/tmp/ld-uClibc.so.0 /tmp/busybox echo -e "Inject END."  | /tmp/ld-uClibc.so.0 /tmp/busybox logger -t miio_ota	

return 0