#!/bin/bash
ACCESSKEY="/home/sonhai/cloudbf12.pem"
USERNAME="sonhai"
BFADD="testdir/Bigfoot.lst"

for i in 01 02 03 04 05 06 07 08 09 10; do
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-read-1thread-test.fio $BFADD
mv testout BigfootSeqRead1thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-write-1thread-test.fio $BFADD
mv testout BigfootSeqWrite1thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-read-2thread-test.fio $BFADD
mv testout BigfootSeqRead2thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-write-2thread-test.fio $BFADD
mv testout BigfootSeqWrite2thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-read-4thread-test.fio $BFADD
mv testout BigfootSeqRead4thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-write-4thread-test.fio $BFADD
mv testout BigfootSeqWrite4thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-read-8thread-test.fio $BFADD
mv testout BigfootSeqRead8thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-write-8thread-test.fio $BFADD
mv testout BigfootSeqWrite8thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-read-16thread-test.fio $BFADD
mv testout BigfootSeqRead16thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-write-16thread-test.fio $BFADD
mv testout BigfootSeqWrite16thread$i
done

echo 'Hi, your test is finish!' | mail -s "Test is finish!" hasonhai124@gmail.com
