#!/system/bin/sh


# This script contains parts from the Open GApps Project by mfonville.

# Testing script.
# ipdev @ xda-developers


get_file_prop() { grep -m1 "^$2=" "$1" | cut -d= -f2-; }

PROPFILES="$g_prop /system/default.prop /system/build.prop /system/vendor/build.prop /system/product/build.prop /system/system_ext/build.prop /vendor/build.prop /product/build.prop /system_ext/build.prop /system_root/default.prop /system_root/build.prop /system_root/vendor/build.prop /system_root/product/build.prop /system_root/system_ext/build.prop /data/local.prop /default.prop /build.prop"

get_prop() {
  #check known .prop files using get_file_prop
  local propfile propval
  for propfile in $PROPFILES; do
    if [ "$propval" ]; then
      break
    else
      propval="$(get_file_prop $propfile $1 2>/dev/null)"
    fi
  done
  #if propval is no longer empty output current result; otherwise try to use recovery's built-in getprop method
  if [ "$propval" ]; then
    echo "$propval"
  else
    getprop "$1"
  fi
}


echo "";
# Check to make certain that user device matches the architecture
[ "$(get_prop "ro.product.cpu.abilist")" = "$(get_prop "ro.system.product.cpu.abilist")" ] && device_architecture="$(get_prop "ro.product.cpu.abilist")";
if [ -z "$device_architecture" ]; then
  echo "  Device Arch is empty " $device_architecture; echo"";
  if [ -n "$(get_prop "ro.system.product.cpu.abilist")" ]; then
    device_architecture="$(get_prop "ro.system.product.cpu.abilist")" && echo "  Device Arch is system.product abilist " $device_architecture; echo "";
  elif [ -n "$(get_prop "ro.vendor.product.cpu.abilist")" ]; then
    device_architecture="$(get_prop "ro.vendor.product.cpu.abilist")" && echo "  Device Arch is vendor.product abilist " $device_architecture; echo "";
  elif [ -n "$(get_prop "ro.product.cpu.abi")" ]; then
    device_architecture="$(get_prop "ro.product.cpu.abi")" && echo "  Device Arch is abi " $device_architecture; echo "";
  else
    device_architecture="$(get_prop "ro.product.cpu.abilist")" && echo "  Device Arch is product abilist " $device_architecture; echo "";
  fi;
fi;


case "$device_architecture" in
  *x86_64*) arch="x86_64"; libfolder="lib64";;
  *x86*) arch="x86"; libfolder="lib";;
  *arm64*) arch="arm64"; libfolder="lib64";;
  *armeabi*) arch="arm"; libfolder="lib";;
  *) arch="unknown";;
esac

echo ""; echo "  Device is "$arch; echo "";

return 0; exit 0;