#!/bin/bash
ACCESSKEY="testdir/hasonhai.cer"
USERNAME="ubuntu"
VMADD="testdir/vm4core.lst"

for i in 01 02 03 04 05 06 07 08 09 10; do
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-read-1thread-test.fio $VMADD
mv testout OneVMFourCoreSeqRead1thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-write-1thread-test.fio $VMADD
mv testout OneVMFourCoreSeqWrite1thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-read-2thread-test.fio $VMADD
mv testout OneVMFourCoreSeqRead2thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-write-2thread-test.fio $VMADD
mv testout OneVMFourCoreSeqWrite2thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-read-4thread-test.fio $VMADD
mv testout OneVMFourCoreSeqRead4thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-write-4thread-test.fio $VMADD
mv testout OneVMFourCoreSeqWrite4thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-read-8thread-test.fio $VMADD
mv testout OneVMFourCoreSeqRead8thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-write-8thread-test.fio $VMADD
mv testout OneVMFourCoreSeqWrite8thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-read-16thread-test.fio $VMADD
mv testout OneVMFourCoreSeqRead16thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-write-16thread-test.fio $VMADD
mv testout OneVMFourCoreSeqWrite16thread$i
done

echo 'Hi, your test is finish!' | mail -s "Test is finish!" hasonhai124@gmail.com
