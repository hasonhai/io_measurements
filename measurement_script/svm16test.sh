#!/bin/bash
ACCESSKEY="/home/sonhai/cloudbf12.pem"
USERNAME="ubuntu"
VMSPEC=$1
DEVICE="sda"

case $VMSPEC in
  OneCore )
    VMADD="testdir/vm1core.lst";;
  TwoCore )
    VMADD="testdir/vm2core.lst";;
  FourCore )
    VMADD="testdir/vm4core.lst";;
  EightCore )
    VMADD="testdir/vm8core.lst";;
  16Core )
    VMADD="testdir/vm16core.lst";;
  * )
    VMADD="testdir/vm1core.lst"
    VMSPEC="OneCore";;
esac

for i in 01 02 03 04 05 06 07 08 09 10; do

time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-read-1thread-test.fio $VMADD $DEVICE VM
mv ${DEVICE}.diskstat testout/OneVM${VMSPEC}SeqRead1thread${i}.diskstat
mv usage.cpustat testout/OneVM${VMSPEC}SeqRead1thread${i}.cpustat
mv testout OneVM${VMSPEC}SeqRead1thread$i

time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-write-1thread-test.fio $VMADD $DEVICE VM
mv ${DEVICE}.diskstat testout/OneVM${VMSPEC}SeqWrite1thread${i}.diskstat
mv usage.cpustat testout/OneVM${VMSPEC}SeqWrite1thread${i}.cpustat
mv testout OneVM${VMSPEC}SeqWrite1thread$i

time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-read-2thread-test.fio $VMADD $DEVICE VM
mv ${DEVICE}.diskstat testout/OneVM${VMSPEC}SeqRead2thread${i}.diskstat
mv usage.cpustat testout/OneVM${VMSPEC}SeqRead2thread${i}.cpustat
mv testout OneVM${VMSPEC}SeqRead2thread$i

time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-write-2thread-test.fio $VMADD $DEVICE VM
mv ${DEVICE}.diskstat testout/OneVM${VMSPEC}SeqWrite2thread${i}.diskstat
mv usage.cpustat testout/OneVM${VMSPEC}SeqWrite2thread${i}.cpustat
mv testout OneVM${VMSPEC}SeqWrite2thread$i

time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-read-4thread-test.fio $VMADD $DEVICE VM
mv ${DEVICE}.diskstat testout/OneVM${VMSPEC}SeqRead4thread${i}.diskstat
mv usage.cpustat testout/OneVM${VMSPEC}SeqRead4thread${i}.cpustat
mv testout OneVM${VMSPEC}SeqRead4thread$i

time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-write-4thread-test.fio $VMADD $DEVICE VM
mv ${DEVICE}.diskstat testout/OneVM${VMSPEC}SeqWrite4thread${i}.diskstat
mv usage.cpustat testout/OneVM${VMSPEC}SeqWrite4thread${i}.cpustat
mv testout OneVM${VMSPEC}SeqWrite4thread$i

time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-read-8thread-test.fio $VMADD $DEVICE VM
mv ${DEVICE}.diskstat testout/OneVM${VMSPEC}SeqRead8thread${i}.diskstat
mv usage.cpustat testout/OneVM${VMSPEC}SeqRead8thread${i}.cpustat
mv testout OneVM${VMSPEC}SeqRead8thread$i

time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-write-8thread-test.fio $VMADD $DEVICE VM
mv ${DEVICE}.diskstat testout/OneVM${VMSPEC}SeqWrite8thread${i}.diskstat
mv usage.cpustat testout/OneVM${VMSPEC}SeqWrite8thread${i}.cpustat
mv testout OneVM${VMSPEC}SeqWrite8thread$i

time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-read-16thread-test.fio $VMADD $DEVICE VM
mv ${DEVICE}.diskstat testout/OneVM${VMSPEC}SeqRead16thread${i}.diskstat
mv usage.cpustat testout/OneVM${VMSPEC}SeqRead16thread${i}.cpustat
mv testout OneVM${VMSPEC}SeqRead16thread$i

time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-write-16thread-test.fio $VMADD $DEVICE VM
mv ${DEVICE}.diskstat testout/OneVM${VMSPEC}SeqWrite16thread${i}.diskstat
mv usage.cpustat testout/OneVM${VMSPEC}SeqWrite16thread${i}.cpustat
mv testout OneVM${VMSPEC}SeqWrite16thread$i

done

echo 'Hi, your test is finish!' | mail -s "Test is finish!" hasonhai124@gmail.com
