#!/system/bin/sh

## Magisk OTA Survival module.
## This module will overlay Magisk's addon.d script into the system/addon.d directory if it exists.
## ipdev @ xda-developers

# __ Define variables. __

### Magisk variables
## MODPATH (path): the path where your module files should be installed.

# ADB Directory
ADB=/data/adb

# __ Define functions. __

### Magisk functions
## set_perm <target> <owner> <group> <permission> [context]

# __ Here we go. __

if [ -d /system/addon.d ]; then
	# Copy the current addon.d script.
	cp "$ADB"/magisk/addon.d.sh "$MODPATH"/system/addon.d/99-magisk.sh

	# Set owner, group, permission and security.
	set_perm "$MODPATH"/system/addon.d/99-magisk.sh 0 0 0755 u:object_r:system_file:s0
else
	echo "This device does not support addon.d scripts."
	exit 1
fi

# __ Finish and Cleanup. __
