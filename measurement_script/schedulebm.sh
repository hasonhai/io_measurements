#!/bin/bash
appdir="/home/sonhai/io_measurements/measurement_script/"
for drive in sda sdg sdh sdi sdj;
do
    sed -i "s|/home/sonhai/fiodata|/mnt/${drive}/fiodata|g" $appdir/testdir/*.fio 
    $appdir/bigfootprocs16test.sh
    mv $appdir/BigfootSeq* $appdir/procs16_${drive}/
done
