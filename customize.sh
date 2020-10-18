# Script customize.sh

# Log
LOGFILE=/data/local/tmp/debloat.log
echo ${0} debloat > $LOGFILE
echo $(date +%c) >> $LOGFILE

# Magisk Module Installer variable
REPLACE=""

# Stock app names for debloating - add/remove app names you want to debloat
for X in AnalyticsCore BasicDreams BookmarkProvider Calculator CatchLog EasterEgg facebook-appmanager FileExplorer_old HybridAccessory HybridPlatform IdMipay InMipay Joyose Lens MiPicks MiuiBugReport MiuiDaemon MiWallpaper MSA-Global Netflix_activation PartnerBookmarksProvider PaymentService Stk TouchAssistant Traceur Zman MiCreditInStub facebook-installer facebook-services GameCenterGlobal GlobalMinusScreen MiBrowserGlobal MiDrop MiRcs MiRecycle MiService MiuiBrowserGlobal YellowPage Chrome Gmail2 PhotoTable AndroidAutoStub GoogleFeedback GooglePartnerSetup Turbo Wellbeing SoterService GlobalFashiongallery MiBrowserGlobalVendor wps_lite 
do
	z=""; Z=""
	# Search for the system application path
	for x in $X.apk .replace
	do
		y=*app/$X/$x
		if [ -z "$z" ]
		then
			z=$(readlink -f /system/$y)
			if [ -z "$z" ]
			then
				z=$(readlink -f /system/*/$y)
				for w in /product /vendor
				do
					if [ -z "$z" ]
					then
						z=$(readlink -f $w/$y)
					fi
				done
			fi
		fi

		# Check if the path was found
		if [ -z "$Z" ] && [ ! -z "$z" ]
		then
			# Log the path
			echo $z >> $LOGFILE
			# Remove /filename from the end
			Z=$(echo $z | sed "s,/$x$,,g")
			# Prepend /system if not beginning with
			for w in /product /vendor
			do
				Z=$(echo $Z | sed "s,^$w,/system$w,g")
			done
			# Append to the REPLACE var
			REPLACE="$REPLACE$Z "	
		fi
	done

	if [ -z "$z" ]
	then
		# Log app name if not found
		echo $X --- not found >> $LOGFILE
	fi
done

# Log the REPLACE var
echo REPLACE='"'$REPLACE'"' >> $LOGFILE
