#!/bin/bash
ACCESSKEY="/home/sonhai/cloudbf12.pem"
USERNAME="ubuntu"
VMADD="testdir/vm2core.lst"

for i in 01 02 03 04 05 06 07 08 09 10; do
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-read-1thread-test.fio $VMADD
mv testout OneVMTwoCoreSeqRead1thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-write-1thread-test.fio $VMADD
mv testout OneVMTwoCoreSeqWrite1thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-read-2thread-test.fio $VMADD
mv testout OneVMTwoCoreSeqRead2thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-write-2thread-test.fio $VMADD
mv testout OneVMTwoCoreSeqWrite2thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-read-4thread-test.fio $VMADD
mv testout OneVMTwoCoreSeqRead4thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-write-4thread-test.fio $VMADD
mv testout OneVMTwoCoreSeqWrite4thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-read-8thread-test.fio $VMADD
mv testout OneVMTwoCoreSeqRead8thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-write-8thread-test.fio $VMADD
mv testout OneVMTwoCoreSeqWrite8thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-read-16thread-test.fio $VMADD
mv testout OneVMTwoCoreSeqRead16thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-write-16thread-test.fio $VMADD
mv testout OneVMTwoCoreSeqWrite16thread$i
done

echo 'Hi, your test is finish!' | mail -s "Test is finish!" hasonhai124@gmail.com
