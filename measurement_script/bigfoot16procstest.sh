#!/bin/bash
ACCESSKEY="/home/sonhai/cloudbf12.pem"
USERNAME="sonhai"
BFADD="testdir/Bigfoot.lst"
DEVICE="sdj"

# Number of enabled core in the test
if [ "$1" = "" ]; then
    NumCore=32
else
    padtowidth=2
    NumCore=$( printf "%0*d" $padtowidth $1 )
fi

for i in 01 02 03 04 05 06 07 08 09 10; do
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-read-1thread-test.fio $BFADD $DEVICE
mv ${DEVICE}.diskstat testout/Bigfoot${NumCore}CoreSeqRead1thread${i}.diskstat
mv testout Bigfoot${NumCore}CoreSeqRead1thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-write-1thread-test.fio $BFADD $DEVICE
mv ${DEVICE}.diskstat testout/Bigfoot${NumCore}CoreSeqWrite1thread${i}.diskstat
mv testout Bigfoot${NumCore}CoreSeqWrite1thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-read-2thread-test.fio $BFADD $DEVICE
mv ${DEVICE}.diskstat testout/Bigfoot${NumCore}CoreSeqRead2thread${i}.diskstat
mv testout Bigfoot${NumCore}CoreSeqRead2thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-write-2thread-test.fio $BFADD $DEVICE
mv ${DEVICE}.diskstat testout/Bigfoot${NumCore}CoreSeqWrite2thread${i}.diskstat
mv testout Bigfoot${NumCore}CoreSeqWrite2thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-read-4thread-test.fio $BFADD $DEVICE
mv ${DEVICE}.diskstat testout/Bigfoot${NumCore}CoreSeqRead4thread${i}.diskstat
mv testout Bigfoot${NumCore}CoreSeqRead4thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-write-4thread-test.fio $BFADD $DEVICE
mv ${DEVICE}.diskstat testout/Bigfoot${NumCore}CoreSeqWrite4thread${i}.diskstat
mv testout Bigfoot${NumCore}CoreSeqWrite4thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-read-8thread-test.fio $BFADD $DEVICE
mv ${DEVICE}.diskstat testout/Bigfoot${NumCore}CoreSeqRead8thread${i}.diskstat
mv testout Bigfoot${NumCore}CoreSeqRead8thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-write-8thread-test.fio $BFADD $DEVICE
mv ${DEVICE}.diskstat testout/Bigfoot${NumCore}CoreSeqWrite8thread${i}.diskstat
mv testout Bigfoot${NumCore}CoreSeqWrite8thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-read-16thread-test.fio $BFADD $DEVICE
mv ${DEVICE}.diskstat testout/Bigfoot${NumCore}CoreSeqRead16thread${i}.diskstat
mv testout Bigfoot${NumCore}CoreSeqRead16thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-write-16thread-test.fio $BFADD $DEVICE
mv ${DEVICE}.diskstat testout/Bigfoot${NumCore}CoreSeqWrite16thread${i}.diskstat
mv testout Bigfoot${NumCore}CoreSeqWrite16thread$i
done

echo 'Hi, your test is finish!' | mail -s "Test is finish!" hasonhai124@gmail.com
