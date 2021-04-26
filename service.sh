# Wait untill boot is compleate before moving on.
while [ "$(getprop sys.boot_completed)" != 1 ];
do sleep 1;
done;

# Get YouTube path = Android 11
YTPATH=$(readlink -f /data/app/*/com.google.android.youtube*/oat | sed 's/\/oat//g')

# Check if path exists
if [ ! -z "$YTPATH" ]
then
	# Swap stock YouTube with Vanced YouTube.
	su -c mount $MODDIR/base.apk $YTPATH/base.apk
else
	# Get YouTube path < Android 11
	YTPATH=$(readlink -f /data/app/com.google.android.youtube*/oat | sed 's/\/oat//g')
	
	# Check if path exists
	if [ ! -z "$YTPATH" ]
	then
		# Swap stock YouTube with Vanced YouTube.
		su -c mount $MODDIR/base.apk $YTPATH/base.apk
	fi
fi
