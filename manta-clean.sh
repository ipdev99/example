#!/bin/sh

fastboot erase boot
fastboot erase system
fastboot erase userdata
fastboot erase cache
fastboot erase recovery

fastboot reboot bootloader
sleep 20

fastboot format system
fastboot -w

fastboot flash recovery /ip/twrp/twrp-3.6.2_9-0-manta.img
# fastboot boot /ip/twrp/twrp-3.6.2_9-0-manta.img
## Manta does not support booting TWRP image. Have to use volume keys to select recovery then power to boot recovery.