#!/bin/sh

fastboot erase boot
fastboot erase system
fastboot erase userdata
fastboot erase cache
fastboot erase recovery

fastboot reboot bootloader
sleep 5

fastboot format boot
fastboot format system
fastboot -w

fastboot boot /ip/roms/recovery/recovery-ryu-opm8.190605.005.img
sleep 60

fastboot flash recovery /ip/twrp/twrp-3.6.2_9-1-dragon_followmsi.img
fastboot boot /ip/twrp/twrp-3.6.2_9-1-dragon_followmsi.img
