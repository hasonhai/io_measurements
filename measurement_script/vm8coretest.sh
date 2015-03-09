#!/bin/bash
ACCESSKEY="/home/sonhai/cloudbf12.pem"
USERNAME="ubuntu"
VMADD="testdir/vm8core.lst"

for i in 01 02 03 04 05 06 07 08 09 10; do
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-read-1thread-test.fio $VMADD
mv testout OneVMEightCoreSeqRead1thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-write-1thread-test.fio $VMADD
mv testout OneVMEightCoreSeqWrite1thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-read-2thread-test.fio $VMADD
mv testout OneVMEightCoreSeqRead2thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-write-2thread-test.fio $VMADD
mv testout OneVMEightCoreSeqWrite2thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-read-4thread-test.fio $VMADD
mv testout OneVMEightCoreSeqRead4thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-write-4thread-test.fio $VMADD
mv testout OneVMEightCoreSeqWrite4thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-read-8thread-test.fio $VMADD
mv testout OneVMEightCoreSeqRead8thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-write-8thread-test.fio $VMADD
mv testout OneVMEightCoreSeqWrite8thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-read-16thread-test.fio $VMADD
mv testout OneVMEightCoreSeqRead16thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-write-16thread-test.fio $VMADD
mv testout OneVMEightCoreSeqWrite16thread$i
done

echo 'Hi, your test is finish!' | mail -s "Test is finish!" hasonhai124@gmail.com
