# Script customize.sh

# Log
LOGFILE=/data/local/tmp/debloat.log
echo ${0} debloat > $LOGFILE
echo $(date +%c) >> $LOGFILE

# Magisk Module Installer variable
REPLACE=""

# Stock app names for debloating - add/remove app names you want to debloat.
RemoveList='AnalyticsCore
AndroidAutoStub
BasicDreams
BookmarkProvider
Calculator CatchLog
Chrome
EasterEgg
facebook-appmanager
facebook-installer
facebook-services
FileExplorer_old
GameCenterGlobal
GlobalFashiongallery
GlobalMinusScreen
Gmail2
GoogleFeedback
GooglePartnerSetup
HybridAccessory
HybridPlatform
IdMipay
InMipay
Joyose
Lens
lite
MiBrowserGlobal
MiBrowserGlobalVendor
MiCreditInStub
MiDrop
MiPicks
MiRcs
MiRecycle
MiService
MiuiBrowserGlobal
MiuiBugReport
MiuiDaemon
MiWallpaper
MSA-Global
Netflix_activation
PartnerBookmarksProvider
PaymentService
PhotoTable
SoterService
Stk
TouchAssistant
Traceur
Turbo
Wellbeing
wps
YellowPage
YouTube
Zman'

# Systemless deblote.
for X in $RemoveList; do
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
