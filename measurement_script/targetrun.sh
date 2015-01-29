#!/bin/bash
# Script to run on target
# - fio is installed on the target machine
# - config file is copied in the same directory
# - directory for performing test is created at /tmp

Conf="$1"
TestDir="$2"
HostName="$( hostname )"
Now="$(date +'%Y%m%d%H%M')"
FIO="$(which fio)"
echo "Run $FIO at time $Now on $HostName"
$FIO $Conf --minimal > diskout/$HostName-$Now.diskout
