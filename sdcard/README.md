# Modding tool
## SD CARD Structure
The structure of the sdcard (VFAT) is split in accessing the camera subsystem and the tools.
ft folder, used by the camera to update the firmware or getting access to the system
tools folder, used by our modders to support new features

**Files required** (release will be created from these)
- valhalla.sh
- ft/ft_boot_sh
- ft/secret.bin
- tools/*

# Technical Stuff
## Boot flow
When the camara boot up it tries to find if there is a sdcard and a configuration script so tell if maintenance script signed by the provider is required.
There are 5 possible modes (default 0). 
We will focus in the mode 3 by the file ft_config.ini (P2P Mode 3) which allows to start the maintenance script (ft/ft_boot.sh)
which is run if the checkum signed by the provider (ft/secure.bin) is succesfully validated with the private key.

## Camera maintenance script
To avoid to have to sign the ft/ft_boot.sh checksum every single time a new feature requires to be added, the ft_boot.sh has been
populated with the only entry of calling the script valhalla.sh.
* Note: ft_boot.sh is called by /etc/init.d/S50gm *

## Tool customization
valhalla.sh has to be located in the root of the sdcard, but from there the sky is the limit. To maintain an order, the tools folder
should be used for binary/library, auxiliary script, etc.


############################################
############################################
############################################
############################################

## Signing ft/ft_boot.sh
This is **only** required if the private key has changed in a firmware upgrade.
md5sum and openssl are the only tools required.

### Steps:
- md5sum ft/ft_boot.sh > secure.bin.dec
- edit secure.bin.dec and change the path of the file to /tmp/sd/ft/ (this is required by the Camera Core script)
- openssl rsautl -encrypt -inkey prikey.pem -in secure.bin.dec -out ft/secret.bin

*prikey.pem is the private key stored in the /data partition*

