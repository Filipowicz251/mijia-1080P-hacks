#!/bin/sh

WPA_SUPPLICANT_CONFIG_FILE="/tmp/wpa_supplicant.conf"

update_wpa_conf()
{
    if [ x"$2" = x ]; then
    cat <<EOF > $WPA_SUPPLICANT_CONFIG_FILE
ctrl_interface=/var/run/wpa_supplicant
update_config=1
network={
        ssid="$1"
        key_mgmt=NONE
	scan_ssid=1
}
EOF
    else
    cat <<EOF > $WPA_SUPPLICANT_CONFIG_FILE
ctrl_interface=/var/run/wpa_supplicant
update_config=1
network={
        ssid="$1"
        psk="$2"
        key_mgmt=WPA-PSK
	proto=WPA WPA2
	scan_ssid=1
}
EOF
    fi
}

wifi_ap_mode()
{
    echo "Enabling wifi AP mode"

    # wifi stop
    ifconfig mlan0 down
    killall udhcpc wpa_supplicant hostapd wpa_cli udhcpd
    ifconfig uap0 up
    ifconfig uap0 192.168.14.1 netmask 255.255.255.0
    cp /etc/hostapd.conf /tmp/

    if [[ -z $AP_SSID ]]; then
        MODEL=`/usr/sbin/nvram factory get model`
        vendor=`echo ${MODEL} | cut -d '.' -f 1`
        product=`echo ${MODEL} | cut -d '.' -f 2`
        version=`echo ${MODEL} | cut -d '.' -f 3`
        echo "ssid=${vendor}-${product}-${version}_mibt$1" >> /tmp/hostapd.conf
    else
        echo "ssid=$AP_SSID" >> /tmp/hostapd.conf
    fi

    mkdir -p /var/run/hostapd
    hostapd /tmp/hostapd.conf -B

    mkdir -p /var/lib/misc
    touch /var/lib/misc/udhcpd.leases
    udhcpd
}

wifi_sta_mode()
{
    echo "Enabling wifi STA mode"

    get_ssid_passwd
    update_wpa_conf "$ssid" "$passwd"

    #stop uap interfce
    killall udhcpc wpa_supplicant hostapd udhcpd wpa_cli
    ifconfig uap0 down
	
    ifconfig mlan0 up
    iwconfig mlan0 mode Managed
    mkdir -p /var/run/wpa_supplicant
    wpa_supplicant -Dnl80211 -imlan0 -c $WPA_SUPPLICANT_CONFIG_FILE -B
   
    wpa_cli -i mlan0 -B -a /mnt/data/ot_wifi_tool/wpa_event.sh 
    udhcpc -i mlan0 -S

    # check if we've got ip
    echo "get ip addr :"
    ifconfig mlan0 | grep "inet addr" | cut -d ':' -f 2 |cut -d ' ' -f 1
}

get_ssid_passwd()
{
    ssid=`/usr/sbin/nvram get miio_ssid`
    key_mgmt=`/usr/sbin/nvram get miio_key_mgmt`
    if [ $key_mgmt == "NONE" ]; then
	passwd=""
    else
	passwd=`/usr/sbin/nvram get miio_passwd`
    fi
}

start()
{
    wifi_ready=`/usr/sbin/nvram get miio_ssid`
    if [ x"$wifi_ready" = x ]; then
	wifi_ready="no"
    else
	wifi_ready="yes"
    fi

    if [ $wifi_ready = "yes" ]; then
	wifi_sta_mode
    else
	STRING=`ifconfig mlan0`

	macstring=${STRING##*HWaddr }
	macstring=`echo ${macstring} | cut -d ' ' -f 1`

	mac1=`echo ${macstring} | cut -d ':' -f 5`
	mac2=`echo ${macstring} | cut -d ':' -f 6`
	MAC=${mac1}${mac2}

	wifi_ap_mode $MAC
    fi
}

start
