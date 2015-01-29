#!/bin/sh
now="$(date +'%m%d%Y')"
echo 1 vms
nova start vm1core
sleep 180
./vm1coretest.sh > log_vm01core$now
sleep 10
nova stop vm1core
echo 2 vms
nova start vm2core
sleep 180
./vm2coretest.sh > log_vm02core$now
sleep 10
nova stop vm2core
echo 4 vms
nova start vm4core
sleep 180
./vm4coretest.sh > log_vm04core$now
sleep 10
nova stop vm4core
echo  8vms
nova start vm8core
sleep 180
./vm8coretest.sh > log_vm08core$now
sleep 10
nova stop vm8core
echo 16 vms
nova start vm16core
sleep 180
./vm16coretest.sh > log_vm16core$now
sleep 10
nova stop vm16core
