#!/bin/bash

# Pull the boot.img from current google factory images

TDIR=$(pwd)

for zip in *.zip; do
{
unzip "$zip" "*.zip" -d tmp
NAME=$(printf "$zip" | cut -f1,2 -d '-');
OUT="$NAME"-boot.img
cd tmp/"$NAME"/
unzip image-*.zip "boot.img" -d "$TDIR"/
cd "$TDIR"
mv boot.img "$OUT"
rm -rf tmp
}
done

exit 0;
