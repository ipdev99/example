#!/bin/bash

## Zip Magisk Modules
## ipdev @ xda-developers

# Set main variables

DATE=$(date '+%Y%m%d')
TDIR=$(pwd)
# OUT="$TDIR"/out/"$DATE"
OUT="$TDIR"/out

# Set module variables

NAME=MagiskSurvival
VER=1

# Set additional variables

ZIPNAME="$NAME"-v"$VER".zip


# Lets go

[[ ! -d $OUT ]] && mkdir -p $OUT;

zip -r "$OUT"/"$ZIPNAME" META-INF/* system/* base.apk customize.sh module.prop post-fs-data.sh service.sh system.prop

# Finish script.
echo ""; echo "Done."; echo "";
exit 0;
