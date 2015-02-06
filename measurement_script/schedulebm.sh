#!/bin/bash
appdir="/home/sonhai/io_measurements/measurement_script/"

if [ "$1" = "" ]; then
    oldtestdir="/mnt/sdh/fiodata"
else oldtestdir="$1"
fi

for drive in sdi sdj;
do
    newtestdir="/mnt/${drive}/fiodata"
    echo "Doing test at drive $drive"
    sed -i "s|${oldtestdir}|${newtestdir}|g" $appdir/testdir/*.fio 
    $appdir/bigfoot16procstest.sh
    mv $appdir/BigfootSeq* $appdir/procs16_${drive}/
    oldtestdir="$newtestdir"
done
