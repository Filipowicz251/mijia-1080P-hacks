
![Alt text](images/mijia_1080p/Mijia1080.png?raw=true "Title")

# mijia-1080P

Toolset for Mijia 1080p to enhance the features of this Xiaomi Camera.

### Features:
* SSH and SFTP Server
* Voices in English (Instead of Chinese)
* RTSP (lite version) https://github.com/willthrom/rtspServer_gm
* Todo
    * Better RTSP Server with security
    * Web Service for configuration (maybe)
    * .....

# Use
Download the latest release from [Releases](https://github.com/Filipowicz251/mijia-1080P-hacks/releases) to a fat32 SDCARD, insert in the camera and turn it on.

# Chat for discussion
https://gitter.im/fang-hacks/Mijia-1080P

# Advance Development Info
All the information relevant to customizations and development of the tools can be found in the [wiki](https://github.com/Filipowicz251/mijia-1080P-hacks/wiki) 
 
# How to use on the latest firmware

They changed the keys and the encrypted md5 has of the ft directory is no longer valid. The camera won't load /tmp/sd/ft/ft_boot.sh any more.

If you can dump and rewrite the firmware, do the following.

### Step 1, dump the firmware

```
flashrom -p linux_spi:dev=/dev/spidev0.0,spispeed=10000 -c GD25Q128B -r mijia.camera.v1.bin
```

### Step 2, extract and mount squashfs partition

```
dd if=mijia.camera.v1.bin of=rootfs.bin skip=3145728 count=10485760 bs=1
mkdir fm to temp fin
sudo mount rootfs.bin fm -t squashfs -o loop
sudo mount -t overlay -o lowerdir=fm,upperdir=to,workdir=temp overlay fin
```

### Step 3, edit out the md5 hash verification

```
sudo nano fin/etc/init.d/rcS
```
Reduce everything inside `if [ "$ft_mode" != "0" ];then ... fi` to this.
```
mkdir $ft_running_dir
if cp -r $sd_mountdir/ft/* $ft_running_dir;then
   echo "ft running is ready"
else
   echo "cp ft fail"
   ft_mode="0"
fi
```

### Step 4, re-create the firmware

```
sudo mksquashfs fin rootfs.PATCHED.bin -comp xz
cp mijia.camera.v1.bin mijia.camera.v1.PATCHED.bin
dd if=rootfs.PATCHED.bin of=mijia.camera.v1.PATCHED.bin seek=3145728 count=10485760 bs=1 conv=notrunc
```

### Step 5, clean-up

```
sudo umount fin
sudo umount fm
sudo rm -R fm fin temp to
```

### Step 6, write back the patched firmware

```
flashrom -p linux_spi:dev=/dev/spidev0.0,spispeed=10000 -c GD25Q128B -w mijia.camera.v1.PATCHED.bin
```

### Step 7, remove the version check from valhalla.sh on the sd card

```
#if [ -z "${VERSION_FIRMWARE##*0099*}" ];then 
	echo -e "...Init GM Driver for 0099 version..."  >> $sd_mountdir/$LOGFILE 2>&1
	CONFIG_PARTITION=/gm/config
	echo -e "vg boot"
	sh ${CONFIG_PARTITION}/vg_boot.sh ${CONFIG_PARTITION}
#if
```
