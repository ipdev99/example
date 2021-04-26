# Wait untill boot is compleate before moving on.
while [ "$(getprop sys.boot_completed)" != 1 ];
do sleep 1;
done;

# Get SDK level.
SDK=$(getprop ro.build.version.sdk);

# Find and set YouTube path.
if [ $SDK -ge 30 ]; then
	YTPATH=$(readlink -f /data/app/*/com.google.android.youtube*/lib | sed 's/\/lib//g');
else
	YTPATH=$(readlink -f /data/app/com.google.android.youtube*/lib | sed 's/\/lib//g');
fi;

# Check and swap stock YouTube with Vanced YouTube.
if [ -n $YTPATH ]; then
	if [ $SDK -ge 25 ]; then
		su -c mount $MODDIR/base.apk $YTPATH/base.apk;
	else
		su -c mount -o bind $MODDIR/base.apk $YTPATH/base.apk;
	fi;
fi;
