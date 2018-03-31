SCRIPT_VERSION="1.8"

NOW=$(date +"%Y%m%d%H%M")
LOGFILE="log-$NOW.log"
sd_mountdir=/tmp/sd

echo -e "Customm Script Start v$SCRIPT_VERSION"
echo -e "Running Customm Script v$SCRIPT_VERSION" > $sd_mountdir/$LOGFILE

## Config
##################################################################################			
CLOUD_DISABLED=$(awk -F "=" '/CLOUD_DISABLED/ {print $2}' $sd_mountdir/midgard.ini)
if [ -z "$CLOUD_DISABLED" ];then
 CLOUD_DISABLED=0
fi

CLOUD_STREAMING_DISABLED=$(awk -F "=" '/CLOUD_STREAMING_DISABLED/ {print $2}' $sd_mountdir/midgard.ini)
if [ -z "$CLOUD_STREAMING_DISABLED" ];then
 CLOUD_STREAMING_DISABLED=0
fi

RTSP_ENABLED=$(awk -F "=" '/RTSP_ENABLED/ {print $2}' $sd_mountdir/midgard.ini)
if [ -z "$RTSP_ENABLED" ];then
 RTSP_ENABLED=1
fi

CONFIG_LINE=$(awk -F "=" '/CONFIG_LINE/ {print $2}' $sd_mountdir/midgard.ini)
if [ -z "$CONFIG_LINE" ];then
 CONFIG_LINE="-b4098 -f20 -w1920 -h1080"
fi

SSH_ROOT_PASS=$(awk -F "=" '/SSH_ROOT_PASS/ {print $2}' $sd_mountdir/midgard.ini)
if [ -z "$SSH_ROOT_PASS" ];then
 SSH_ROOT_PASS="qwerty123456"
fi

DISABLED_OTA=$(awk -F "=" '/DISABLED_OTA/ {print $2}' $sd_mountdir/midgard.ini)
if [ -z "$DISABLED_OTA" ];then
 DISABLED_OTA=0
fi

HTTP_ENABLED=$(awk -F "=" '/HTTP_ENABLED/ {print $2}' $sd_mountdir/midgard.ini)
if [ -z "$HTTP_ENABLED" ];then
 HTTP_ENABLED=0
fi

SAMBA_ENABLED=$(awk -F "=" '/SAMBA_ENABLED/ {print $2}' $sd_mountdir/midgard.ini)
if [ -z "$SAMBA_ENABLED" ];then
 SAMBA_ENABLED=0
fi

##################################################################################	

echo -e "\nConfiguration:"  >> $sd_mountdir/$LOGFILE
echo -e "  CLOUD_DISABLED=$CLOUD_DISABLED"  >> $sd_mountdir/$LOGFILE
echo -e "  CLOUD_STREAMING_DISABLED=$CLOUD_STREAMING_DISABLED"  >> $sd_mountdir/$LOGFILE
echo -e "  RTSP_ENABLED=$RTSP_ENABLED"  >> $sd_mountdir/$LOGFILE
echo -e "  CONFIG_LINE=$CONFIG_LINE"  >> $sd_mountdir/$LOGFILE
echo -e "  SSH_ROOT_PASS=$SSH_ROOT_PASS"  >> $sd_mountdir/$LOGFILE
echo -e "  DISABLED_OTA=$DISABLED_OTA"  >> $sd_mountdir/$LOGFILE
echo -e "  HTTP_ENABLED=$HTTP_ENABLED"  >> $sd_mountdir/$LOGFILE
echo -e "  SAMBA_ENABLED=$SAMBA_ENABLED"  >> $sd_mountdir/$LOGFILE

VERSION=/mnt/media/mmcblk0p1/os-release

if [ -f $VERSION ];then
	echo -e "\nos-version block: ">> $sd_mountdir/$LOGFILE
	cat $VERSION >> $sd_mountdir/$LOGFILE 	
fi
VERSION=/etc/os-release
if [ -f $VERSION ];then
	echo -e "os-version">> $sd_mountdir/$LOGFILE
	cat $VERSION >> $sd_mountdir/$LOGFILE 	
else
	echo -e "os-version find"
	find / -name os-release >> $sd_mountdir/$LOGFILE
fi


echo "Forcing Mode 4"  >> $sd_mountdir/$LOGFILE
ft_mode="4"
echo $ft_mode > /tmp/ft_mode


#if [ ! -d $sd_mountdir/tff2 ];then
#	echo -e "\nBacking up /mnt/data partition"  >> $sd_mountdir/$LOGFILE
#	mkdir $sd_mountdir/tff2
#	cp -rf /mnt/data $sd_mountdir/tff2
#fi

echo -e " Staring SSH Server"  >> $sd_mountdir/$LOGFILE

if [ -f $sd_mountdir/tools/dropbear/dropbearmulti ];then		
	## /etc is part of the read-only file system and we need to write the password of root for SSH
	## so just use /tmp and bind to /etc/bind
	echo -e " Getting root access "  >> $sd_mountdir/$LOGFILE
	mkdir /tmp/etc/  >> $sd_mountdir/$LOGFILE		
	cp -r /etc /tmp/   >> $sd_mountdir/$LOGFILE		
	mount --rbind /tmp/etc /etc >> $sd_mountdir/$LOGFILE
	echo -e "$SSH_ROOT_PASS\n$SSH_ROOT_PASS" | passwd >> $sd_mountdir/$LOGFILE 2>&1	
	
	
	mkdir /var/run/   >> $sd_mountdir/$LOGFILE
	PIDFILE="/var/run/dropbear.pid"		
	
	## Part of the testing (I will clean it later)
	mkdir /etc/dropbear
	mkdir /etc/dropbear/etc
	
	## Code to test -- Security Purpose: recover previoys RSA keys from SDCARD	
	if [ -f $sd_mountdir/tools/dropbear/dropbear_ecdsa_host_key ];then
		cp $sd_mountdir/tools/dropbear/dropbear_ecdsa_host_key /etc/dropbear/dropbear_ecdsa_host_key
	fi
		
		
	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$sd_mountdir/tools/libs
		
	echo -e "\n...Starting dropbear..." >> $sd_mountdir/$LOGFILE 2>&1
	$sd_mountdir/tools/dropbear/dropbearmulti dropbear -E -R -p 22 -P $PIDFILE >> $sd_mountdir/$LOGFILE 2>&1
	ln -s mkdir $sd_mountdir/tools/dropbear/dropbearmulti /etc/dropbear/scp
	export PATH=$PATH:/etc/dropbear/	
	## Code to test -- Security Purpose: Save the keys in the SDCARD 
	if [ ! -f $sd_mountdir/tools/dropbear/dropbear_ecdsa_host_key ] && 
		[ -f /etc/dropbear/dropbear_ecdsa_host_key ];then
		cp /etc/dropbear/dropbear_ecdsa_host_key $sd_mountdir/tools/dropbear/dropbear_ecdsa_host_key
	fi
	
	
	echo -e "\n...Changing Language to English..."  >> $sd_mountdir/$LOGFILE 2>&1
	folderVoices=/mnt/data/sound
	fileExample=booting
	parent=`ls -al /mnt/data/sound/booting`
	if [ "${parent%%*cn*}" == ${parent} ];then 
		echo ".....Already installed"
	elif [ -d $folderVoices ];then
		rm $folderVoices/*
		cd $folderVoices/en
		for file in *;do
			ln -s $folderVoices/en/$file $folderVoices/$file
		done
	fi
	
			
	echo -e "...Adding Protection to Change of Keys..."  >> $sd_mountdir/$LOGFILE 2>&1
	#cat /mnt/data/miio_ota/post-ota.sh >> $sd_mountdir/$LOGFILE 2>&1
	
	if [ $DISABLED_OTA -eq 1 ];then
		cp -r /mnt/data/miio_ota/pre-ota.sh /tmp/pre-ota.sh   >> $sd_mountdir/$LOGFILE		
		mount --bind /tmp/pre-ota.sh /mnt/data/miio_ota/pre-ota.sh >> $sd_mountdir/$LOGFILE	
		cat << EOF > /tmp/pre-ota.sh
#!/bin/sh
exit 1

EOF
	fi
	
	#cp $sd_mountdir/tools/pre-ota.sh /mnt/data/miio_ota/pre-ota.sh  >> $sd_mountdir/$LOGFILE 2>&1		
	cp $sd_mountdir/tools/post-ota.sh /mnt/data/miio_ota/post-ota.sh  >> $sd_mountdir/$LOGFILE 2>&1
	cp $sd_mountdir/tools/inject.sh /tmp/inject.sh  >> $sd_mountdir/$LOGFILE 2>&1
	
	
	#cp /mnt/data/miio_ota/miio_ota /tmp/miio_ota    >> $sd_mountdir/$LOGFILE	
	#mount --bind /tmp/miio_ota /mnt/data/miio_ota/miio_ota >> $sd_mountdir/$LOGFILE	
	
	#cp /mnt/data/ot_wifi_tool/miio_recv_line /tmp/miio_recv_line
	#mount --bind /tmp/miio_recv_line /mnt/data/ot_wifi_tool/miio_recv_line >> $sd_mountdir/$LOGFILE	
	
	#cp /mnt/data/ot_wifi_tool/miio_client /tmp/miio_client    >> $sd_mountdir/$LOGFILE	
	#mount --bind /tmp/miio_client /mnt/data/ot_wifi_tool/miio_client >> $sd_mountdir/$LOGFILE	
	
	#cp /mnt/data/ot_wifi_tool/miio_client_helper_nomqtt.sh /tmp/miio_client_helper_nomqtt.sh    >> $sd_mountdir/$LOGFILE	
	#mount --bind /tmp/miio_client_helper_nomqtt.sh /mnt/data/ot_wifi_tool/miio_client_helper_nomqtt.sh >> $sd_mountdir/$LOGFILE
	
		
else
	echo -e "\nSSH Server not found $sd_mountdir/tools/dropbear/dropbear"  >> $sd_mountdir/$LOGFILE 2>&1
fi

hostname Valhalla 

## in Mode 3, the wifi is configured in AP. Restart Wifi in default mode (0).
echo 0 > /tmp/ft_mode
/etc/init.d/S41wifi restart



## Simulate S50gm standard flow (for now)
VERSION_FIRMWARE=`cat $VERSION | grep XIAOMI_VERSION`
if [ -z "${VERSION_FIRMWARE##*0099*}" ];then
	echo -e "...Init GM Driver for 0099 version..."  >> $sd_mountdir/$LOGFILE 2>&1
	CONFIG_PARTITION=/gm/config
	echo -e "vg boot"
	sh ${CONFIG_PARTITION}/vg_boot.sh ${CONFIG_PARTITION}
fi

if [ $CLOUD_DISABLED -eq 1 ];then
	echo -e "...Disabling Cloud...(TODO)"  >> $sd_mountdir/$LOGFILE 2>&1
	# echo "" > /etc/init.d/S59miio_agent
	# echo "" > /etc/init.d/S60miio_avstreamer
	# echo "" > /etc/init.d/S93ble
	#mount --bind /tmp/miio_avstreamer /mnt/data/miio_av/miio_avstreamer
	#echo " echo \"...Disabling Cloud...\" " > /tmp/miio_client
	#mount --bind /tmp/miio_client /mnt/data/ot_wifi_tool/miio_client
	# echo "" > /etc/init.d/S93miio_client
	# /etc/init.d/S51cron stop  >> $sd_mountdir/$LOGFILE 2>&1
	# echo "" > /etc/init.d/S94miio_bt
	# echo "" > /etc/init.d/S94miot_qrcode
	# echo "" > /etc/init.d/S95miio_ota
elif [ $CLOUD_STREAMING_DISABLED -eq 1 ];then
	echo -e "...Disabling Cloud Streaming..."  >> $sd_mountdir/$LOGFILE 2>&1
	echo " echo \"...Disabling Cloud Streaming...\" " > /tmp/miio_avstreamer		 
	mount --bind /tmp/miio_avstreamer /mnt/data/miio_av/miio_avstreamer		 
fi

if [ $RTSP_ENABLED -eq 1 ];then
	echo -e "...Enabling RTSP..." >> $sd_mountdir/$LOGFILE 2>&1
	echo -e "...Enabling RTSP..." > /dev/kmsg
cat <<EOF > /etc/init.d/S99zerlot
#!/bin/sh
#
# end
#

case "\$1" in
  start)
	$sd_mountdir/tools/rtsp_basic $CONFIG_LINE & > $sd_mountdir/${LOGFILE}_RTSP.log 2>&1	
	
	echo "init script all done (TOOLS)" > /dev/kmsg
    ;;
esac

exit $?
EOF

fi

if [ $HTTP_ENABLED -eq 1 ];then
	echo -e "Web Server (8080)" >> $sd_mountdir/$LOGFILE 2>&1
	$sd_mountdir/tools/bin/lighttpd -f $sd_mountdir/tools/etc/lighttpd.conf >> $sd_mountdir/$LOGFILE 2>&1
fi

if [ $SAMBA_ENABLED -eq 1 ];then
	echo -e "Samba setup..." >> $sd_mountdir/$LOGFILE 2>&1
	(echo $SSH_ROOT_PASS; echo $SSH_ROOT_PASS) | $sd_mountdir/tools/bin/smbpasswd -a -s root >> $sd_mountdir/$LOGFILE 2>&1
	$sd_mountdir/tools/bin/smbd -D
fi

echo -e "\nScript Ends. Ok" >> $sd_mountdir/$LOGFILE 2>&1


## Valhalla!!
/mnt/data/miot/ledctl 0 50 2 300 300 2
/mnt/data/miot/ledctl 1 50 2 400 200 2
sleep 5
/mnt/data/miot/ledctl 0 1 1 100 200 2
/mnt/data/miot/ledctl 1 1 1 100 200 2
