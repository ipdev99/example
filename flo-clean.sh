#!/bin/sh

fastboot erase boot
fastboot erase system
fastboot erase userdata
fastboot erase cache
fastboot erase recovery

fastboot reboot bootloader
sleep 5

fastboot format system
fastboot -w

fastboot flash recovery /ip/twrp/twrp-3.6.2_9-0-flo_followmsi.img
fastboot boot /ip/twrp/twrp-3.6.2_9-0-flo_followmsi.img
