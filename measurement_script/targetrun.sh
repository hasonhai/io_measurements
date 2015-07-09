#!/bin/bash
# Script to run on target
# - fio is installed on the target machine
# - config file is copied in the same directory
# - directory for performing test is created at /tmp

Conf="$1"
TestDir="$2"
Mode="$3"
HostName="$( hostname )"
Now="$(date +'%Y%m%d%H%M')"
FIO="$(which fio)"
echo "Run $FIO at time $Now on $HostName"
if [ "$Mode" = "PROCESS" ]; then # TODO: Fix Bugs fot this section
  PNUM=$( grep "numjobs" $Conf | cut -d'=' -f2 )
  if [ "$PNUM" = "" ]; then PNUM=1; fi
  echo Number of parallel processes: $PNUM
  sed -i '/^numjobs=/d' $Conf #remove numjobs
  for i in `seq $PNUM`; do
    echo Run process $i: $FIO $Conf --minimal 
    $FIO $Conf --minimal >> diskout/$HostName-$Now.diskout &
  done
  for job in `jobs -p`; do
    echo wait for job $job
    wait $job || echo $job fail
  done
elif [ "$Mode" = "MEMORYLIMIT" ]; then
  if [ ! -d "/sys/fs/cgroup/memory/fiogroup" ]; then
     sudo apt-get install cgroup-bin -y
     sudo cgcreate -g memory:fiogroup
     sudo cgset -r memory.limit_in_bytes=$((128*1024*1024)) fiogroup
     sudo chown -R `whoami` /sys/fs/cgroup/memory/fiogroup
  fi
  cgexec -g memory:fiogroup $FIO $Conf --minimal > diskout/$HostName-$Now.diskout
else
  $FIO $Conf --minimal > diskout/$HostName-$Now.diskout
fi
