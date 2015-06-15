#!/bin/bash
appdir="/home/sonhai/io_measurements/measurement_script"
DEVICE="sdj"
SCHEDULER="dealine"
OUTPUTDIR="bigfoot12_cache_deadline_v2"
if [ -d $appdir/$OUTPUTDIR ]; then
    mkdir -p $appdir/$OUTPUTDIR
fi

echo "Select scheduler: $SCHEDULER"
echo deadline | sudo tee /sys/block/$DEVICE/queue/scheduler

#for test in 1 2 4 8 16 32;
for test in 32; #only do test with case of full 32 cores online
do
    # Disable cores
    for cpuNo in $( seq $test 31 );
    do
        # disable core
        echo disable core number $cpuNo
        echo 0 | sudo tee /sys/devices/system/cpu/cpu${cpuNo}/online
    done
    
    # Run test
    NoCore="$test"
    $appdir/bigfoot16procstest.sh $NoCore
    padtowidth=2
    NoCore=$( printf "%0*d" $padtowidth $NoCore )
    mv $appdir/Bigfoot${NoCore}CoreSeq* $appdir/$OUTPUTDIR/
    
    # Enable cores
    for cpuNo in $( seq $test 31 );
    do
        # enable core
        echo enable core number $cpuNo
        echo 1 | sudo tee /sys/devices/system/cpu/cpu${cpuNo}/online
    done    
done
