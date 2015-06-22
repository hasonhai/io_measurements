#!/bin/sh
appdir="/home/sonhai/io_measurements/measurement_script"
DEVICE="sda"
SCHEDULER="cfq"
OUTPUTDIR="bigfoot12_cache_cfq_sync"
if [ ! -d $appdir/$OUTPUTDIR ]; then
    mkdir -p $appdir/$OUTPUTDIR
fi

echo "Select scheduler: $SCHEDULER"
echo $SCHEDULER | sudo tee /sys/block/$DEVICE/queue/scheduler

now="$(date +'%m%d%Y')"
echo 1-core vm
nova start vm1core
sleep 180
# Try turn-off huge page to see the effect
./svm16test.sh OneCore > log_vm01core$now
sleep 10
nova stop vm1core
echo 2-core vm
nova start vm2core
sleep 180
./svm16test.sh TwoCore > log_vm02core$now
sleep 10
nova stop vm2core
echo 4-core vm
nova start vm4core
sleep 180
./svm16test.sh FourCore > log_vm04core$now
sleep 10
nova stop vm4core
echo  8-core vm
nova start vm8core
sleep 180
./svm16test.sh EightCore > log_vm08core$now
sleep 10
nova stop vm8core
echo 16-core vm
nova start vm16core
sleep 180
./svm16test.sh 16Core > log_vm16core$now
sleep 10
nova stop vm16core

echo 16 vms
for vm in $( cat OpenStack/vmsmalllist ); do echo starting vm $vm; nova start $vm; done
sleep 300
./mvm16test.sh > log_16vms$now
sleep 10
for vm in $( cat OpenStack/vmsmalllist ); do echo stopping vm $vm; nova stop $vm; done

mv *VM*Seq*thread* $appdir/$OUTPUTDIR/

echo 'Hi, all the tests are done!' | mail -s "Test is finish!" hasonhai124@gmail.com
