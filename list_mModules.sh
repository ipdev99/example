#!/system/bin/sh

# Generate a list of installed magisk Modules.
# ipdev @ xda-developers

# To use.
#
#  NOTE: needs to be run as root.
#
# Copy this script to the device.
# Run from adb shell (or a terminal app) using the sh command.
#  sh list_mModules.sh
# Run from a file manager that is able to execute a script file.
#  Note: May or may not work depending on file manager..


# Set main variables
# DATE=$(date '+%Y%m%d')
DATE=$(date '+%Y%m%d_%H%M')
TDIR=$(pwd)
SCRIPT=list_mModules.sh

# Set additional variables
OUT=mModules_$DATE.txt
# MINVCODE=23010

# Set main functions

check_android_device() {
    [ -f /system/bin/sh ] || [ -f /system/bin/toybox ] || [ -f /system/bin/toolbox ] && ANDROID=TRUE;
    if [ -z "$ANDROID" ]; then
        echo ""; echo " This script needs to be run on an Android device. "; echo "";
        exit 0
    fi
}

set_target_directory() {
    if [ ! -f "$SCRIPT" ]; then
        TDIR=$(lsof 2>/dev/null | grep -o '[^ ]*$' | grep -m1 "$SCRIPT" | sed 's/\/'"$SCRIPT"'//g')
        cd $TDIR
    fi
}

# Set additional functions

check_magisk_ver() {
    MAGISKVCODE=$(magisk -V 2> /dev/null)
    if [ -z "$MAGISKVCODE" ]; then
        echo ""; echo " Requires Magisk to be installed and active. "; echo "";
        exit 0
    else
        MAGISKBLD=$(magisk -v | cut -f1 -d ':')
    fi

    # if [ "$MAGISKVCODE" -lt "$MINVCODE" ]; then
    #   echo ""; echo " Requires Magisk ("$MINVCODE") to be installed and active. ";
    #   echo "  Installed version is ("$MAGISKVCODE")"; echo "";
    #   exit 0;
    # fi;
}

check_modules() {
    if [ ! "$(find /data/adb/modules/ -mindepth 1 -name 'module.prop')" ]; then
        echo ""; echo " No Magisk modules installed."; echo ""
        exit 0
    else
        echo "List of installed Magisk modules." > $OUT
        echo " "$(date '+%Y %B %d') >> $OUT
        echo " Current Magisk is "$(magisk -c) >> $OUT
        echo "" >> $OUT
    fi
}

get_module_prop() {
    mID=$(grep id= $i | cut -f2 -d "=")
    mName=$(grep name= $i | cut -f2 -d "=")
    mVer=$(grep version= $i | cut -f2 -d "=" | sed 's/^v//')
    mVerCode=$(grep versionCode= $i | cut -f2 -d "=")
    mAuthor=$(grep author= $i | cut -f2 -d "=")
    # echo $mName" v."$mVer >> $OUT
    echo $mName" "$mVer >> $OUT
    echo "["$mID" ("$mVerCode")]" >> $OUT
    echo "by "$mAuthor >> $OUT
    echo "" >> $OUT
}

# Lets go.

# Determine if running on an Android device.
check_android_device

# Reset and move to the target directory if needed.
set_target_directory

# Determine if Magisk is installed and running.
check_magisk_ver

# Check if Magisk modules are installed. Exit or start the list file.
check_modules

# # Cat each module prop file.
# for i in $(find /data/adb/modules/ -mindepth 1 -name 'module.prop'); do
#     mPath=$(printf $i | sed 's/module.prop//g');
#     # [ -f "$mPath""disable" ] && echo " ## This module is disabled. ";
#     if [ -f "$mPath""disable" ]; then
#         ii=$(cat $i | grep id= | cut -f2 -d'=');
#         echo " ## "$ii" module is disabled." >>$OUT;
#     fi;
#     cat $i >> $OUT;
#     echo "" >> $OUT;
# done;

# Add enabled Magisk modules to the list.
for i in $(find /data/adb/modules/ -mindepth 1 -name 'module.prop'); do
    ii=$(printf $i | sed 's/module.prop//g')
    [ ! -f "$ii""disable" ] && get_module_prop
done

# Add disabled Magisk modules to the list.
if [ ! -z "$(find /data/adb/modules/ -mindepth 1 -name 'disable')" ]; then
    echo "" >> $OUT
    echo " Disabled modules." >> $OUT
    echo "" >> $OUT
    for i in $(find /data/adb/modules/ -mindepth 1 -name 'module.prop'); do
        ii=$(printf $i | sed 's/module.prop//g')
        [ -f "$ii""disable" ] && get_module_prop
    done
fi

# Finish script
echo ""; echo " Done."; echo "";
echo " New file saved as "$(pwd)"/"$OUT""; echo "";
return 0; exit 0;
