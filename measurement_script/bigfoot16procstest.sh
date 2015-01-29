#!/bin/bash
ACCESSKEY="testdir/hasonhai.cer"
USERNAME="venzano"
BFADD="testdir/Bigfoot.lst"

for i in 01 02 03 04 05 06 07 08 09 10; do
time ./test.sh $ACCESSKEY $USERNAME testdir/procs16test/sequential-read-1thread-test.fio $BFADD
mv testout OneVMOneCoreSeqRead1thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/procs16test/sequential-write-1thread-test.fio $BFADD
mv testout OneVMOneCoreSeqWrite1thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/procs16test/sequential-read-2thread-test.fio $BFADD
mv testout OneVMOneCoreSeqRead2thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/procs16test/sequential-write-2thread-test.fio $BFADD
mv testout OneVMOneCoreSeqWrite2thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/procs16test/sequential-read-4thread-test.fio $BFADD
mv testout OneVMOneCoreSeqRead4thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/procs16test/sequential-write-4thread-test.fio $BFADD
mv testout OneVMOneCoreSeqWrite4thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/procs16test/sequential-read-8thread-test.fio $BFADD
mv testout OneVMOneCoreSeqRead8thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/procs16test/sequential-write-8thread-test.fio $BFADD
mv testout OneVMOneCoreSeqWrite8thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/procs16test/sequential-read-16thread-test.fio $BFADD
mv testout OneVMOneCoreSeqRead16thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/procs16test/sequential-write-16thread-test.fio $BFADD
mv testout OneVMOneCoreSeqWrite16thread$i
done

echo 'Hi, your test is finish!' | mail -s "Test is finish!" hasonhai124@gmail.com
