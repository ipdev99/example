#!/system/bin/sh


# Generic script.
# ipdev @ xda-developers


LOG=$PWD/abi_list.log

PROP="build.prop default.prop prop.default";

for i in $PROP; do
    for ii in $(find / -name $i 2> /dev/null); do
        echo "" >> $LOG;
        echo $ii >> $LOG;
        cat $ii | grep "cpu.abi" >> $LOG;
    done;
done;

echo "" >> $LOG;
echo "End of Log File." >> $LOG;

return 0; exit 0;