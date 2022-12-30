# Poco F1
echo Create image files
adb shell dd if=/dev/block/sde45 of=/sdcard/mi-boot.img
adb shell dd if=/dev/block/sda19 of=/sdcard/mi-recovery.img
adb shell dd if=/dev/block/sde48 of=/sdcard/mi-system.img
adb shell dd if=/dev/block/sde47 of=/sdcard/mi-vendor.img
#
echo Pull image files
adb pull /sdcard/mi-boot.img
adb pull /sdcard/mi-recovery.img
adb pull /sdcard/mi-system.img
adb pull /sdcard/mi-vendor.img
#
echo Erase image files
adb shell rm /sdcard/mi-boot.img
adb shell rm /sdcard/mi-recovery.img
adb shell rm /sdcard/mi-system.img
adb shell rm /sdcard/mi-vendor.img
#
echo Pull vendor files
adb pull /vendor/build.prop
adb pull /vendor/etc/fstab.qcom
cp build.prop mi-build.prop
cp fstab.qcom mi-fstab.qcom
#
echo Done.
