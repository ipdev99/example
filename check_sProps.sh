#!/system/bin/sh

# Check the sensitive [secure] properties of the device.
# ipdev @ xda-developers

# Some devices/manufacturers hide properties from user.
# For best results run this script with root privilege.


# Set main variables

# TDIR=$(pwd)
# SCRIPT=check_sProps.sh

# Set main functions

check_android_device() {
    [ -f /system/bin/sh ] || [ -f /system/bin/toybox ] || [ -f /system/bin/toolbox ] && ANDROID=TRUE;
    if [[ -z $ANDROID ]]; then
        echo ""; echo " This script needs to be run on an Android device. "; echo "";
        exit 0;
    fi;
}

# set_target_directory() {
#     if [ ! -f "$SCRIPT" ]; then
#         TDIR=$(lsof 2>/dev/null | grep -o '[^ ]*$' | grep -m1 "$SCRIPT" | sed 's/\/'"$SCRIPT"'//g');
#         cd $TDIR;
#     fi
# }


# Set additional functions

note_prop_value() {
    if [[ $(getprop $1) ]]; then
        echo " [ Note ]" $1 "is set to" $(getprop $1)
    fi
}

prop_one_value() {
    if [[ $(getprop $1) ]]; then
        if [[ $(getprop $1) != $2 ]]; then
            echo " [ Danger ]" $1 "is set to" $(getprop $1)
            echo "    Safe value is" $2
        else
            echo " [ Safe ]" $1 "is set to" $(getprop $1)
        fi
    fi
}

prop_two_value() {
    if [[ $(getprop $1) ]]; then
        if [[ $(getprop $1) != $2 ]] && [[ $(getprop $1) != $3 ]]; then
            echo " [ Danger ]" $1 "is set to" $(getprop $1)
            echo "    Safe value is" $2 "or" $3
        else
            echo " [ Safe ]" $1 "is set to" $(getprop $1)
        fi
    fi
}

warn_one_value() {
    if [[ $(getprop $1) ]]; then
        if [[ $(getprop $1) != $2 ]]; then
            echo " [ Warning ]" $1 "is set to" $(getprop $1)
            echo "    Safe value is" $2
        else
            echo " [ Safe ]" $1 "is set to" $(getprop $1)
        fi
    fi
}

warn_two_value() {
    if [[ $(getprop $1) ]]; then
        if [[ $(getprop $1) != $2 ]] && [[ $(getprop $1) != $3 ]]; then
            echo " [ Warning ]" $1 "is set to" $(getprop $1)
            echo "    Safe value is" $2 "or" $3
        else
            echo " [ Safe ]" $1 "is set to" $(getprop $1)
        fi
    fi
}


# Lets go.

# Determine if running on an Android device.
check_android_device

# # Reset and move to the target directory if needed.
# set_target_directory


# From Moto
## ro.boot.secure_hardware]: [1]
## ro.vendor.boot.secure_hardware]: [1]

## Poco F2 RedMi
# lmi:/ # getprop | grep 'secur'
# [init.svc.secureelement-hal_1_2]: [running]
# [init.svc_debug_pid.secureelement-hal_1_2]: [1075]
# [persist.security.adbinput]: [1]
# [persist.security.adbinstall]: [1]
# [ro.adb.secure]: [1]
# [ro.boot.secureboot]: [1]
# [ro.boottime.secureelement-hal_1_2]: [4236706403]
# [ro.build.version.security_patch]: [2021-11-01]
# [ro.miui.has_security_keyboard]: [1]
# [ro.secure]: [1]
# [ro.secureboot.devicelock]: [1]
# [ro.secureboot.lockstate]: [unlocked]
# [ro.vendor.build.security_patch]: [2021-11-01]
# [security.perf_harden]: [1]
# lmi:/ # 

# ro.boot.flash.locked]: [0]
# Should be 1

# ro.boot.verifiedbootstate]: [orange]
# Should be green

# ro.boot.hwc]: [GLOBAL]

##______________________________________________________________________

echo ""

# __ Sensitive and/or Secure properties. __

echo "Sensitive and/or Secure properties."; echo "";

warn_one_value ro.adb.secure 1
prop_one_value ro.boot.flash.locked 1
# warn_one_value ro.boot.hwc GLOBAL
warn_two_value ro.boot.hwc GLOBAL GL
# warn_one_value ro.boot.hwcountry GLOBAL
warn_two_value ro.boot.hwcountry GLOBAL GL
prop_two_value ro.boot.mode normal unknown
warn_one_value ro.boot.secure_hardware 1
warn_one_value ro.boot.secureboot 1 ## Not sure if this is needed.
prop_one_value ro.boot.selinux enforcing
prop_one_value ro.boot.vbmeta.device_state locked
prop_one_value ro.boot.verifiedbootstate green
prop_one_value ro.boot.veritymode enforcing
prop_one_value ro.boot.warranty_bit 0
prop_two_value ro.bootmode normal unknown
prop_one_value ro.build.selinux 1
prop_one_value ro.build.tags release-keys
prop_one_value ro.build.type user
prop_one_value ro.debuggable 0
warn_one_value ro.is_ever_orange 0
prop_one_value ro.odm.build.tags release-keys
prop_one_value ro.odm.build.type user
prop_one_value ro.product.build.tags release-keys
prop_one_value ro.product.build.type user
prop_one_value ro.secure 1
warn_one_value ro.secureboot.devicelock 1 ## Not sure if this is needed.
warn_one_value ro.secureboot.lockstate locked ## Not sure if this is needed.
prop_one_value ro.system.build.tags release-keys
prop_one_value ro.system.build.type user
warn_one_value ro.vendor.boot.secure_hardware 1
prop_one_value ro.vendor.boot.warranty_bit 0
prop_one_value ro.vendor.build.tags release-keys
prop_one_value ro.vendor.build.type user
prop_one_value ro.vendor.warranty_bit 0
prop_one_value ro.warranty_bit 0
prop_two_value vendor.boot.mode normal unknown
prop_one_value vendor.boot.vbmeta.device_state locked
prop_one_value vendor.boot.verifiedbootstate green

echo ""

# __ Note properties of interest. __

echo "Properties of interest."; echo "";

note_prop_value ro.oem.key1
note_prop_value ro.oem_unlock_supported
note_prop_value sys.oem_unlock_allowed

echo ""

return 0; exit 0;
