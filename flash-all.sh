#!/bin/sh

# Copyright 2012 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

if ! [ $($(which fastboot) --version | grep "version" | cut -c18-23 | sed 's/\.//g' ) -ge 3301 ]; then
  echo "fastboot too old; please download the latest version at https://developer.android.com/studio/releases/platform-tools.html"
  exit 1
fi
fastboot flash bootloader bootloader-panther-cloudripper-1.0-9231809.img
fastboot reboot-bootloader
sleep 5
fastboot flash radio radio-panther-g5300g-220923-221028-b-9229469.img
fastboot reboot-bootloader
sleep 5
# fastboot -w update image-panther-tq1a.221205.011.zip
fastboot --skip-reboot update image-panther-tq1a.221205.011.zip
fastboot reboot-bootloader
