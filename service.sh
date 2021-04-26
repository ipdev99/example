# Get SDK level.
SDK=$(getprop ro.build.version.sdk);

# Find and set YouTube path.
if [ $SDK -ge 30 ]; then
	YTPATH=$(readlink -f /data/app/*/com.google.android.youtube*/lib | sed 's/\/lib//g');
else
	YTPATH=$(readlink -f /data/app/com.google.android.youtube*/lib | sed 's/\/lib//g');
fi;

# Find installed (active) YouTube versionCode.
if [ -n $YTPATH ]; then
	while [ -z $YTVCODE ]; do
		YTVCODE=$(dumpsys package com.google.android.youtube | grep versionCode | cut -f2 -d'=' | tr -d '\n' | cut -f1 -d' ');
		sleep 1;
	done;
fi;

# Check and swap stock YouTube with Vanced YouTube.
if [ -n $YTVCODE ]; then
	if [ $SDK -ge 25 ]; then
		su -c mount $MODDIR/base.apk $YTPATH/base.apk;
	else
		su -c mount -o bind $MODDIR/base.apk $YTPATH/base.apk;
	fi;
fi;
