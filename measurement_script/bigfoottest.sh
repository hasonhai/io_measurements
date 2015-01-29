#!/bin/bash
ACCESSKEY="testdir/hasonhai.cer" # We need passwordless-ssh access for this script to work
USERNAME="cloud-user" # root is the best, otherwise must be a sudoer
LISTOFHOST="testdir/Bigfoot.lst"

for i in 01 02 03 04 05; do
time ./test.sh $ACCESSKEY $USERNAME testdir/random-read-1thread-test.fio $LISTOFHOST
mv testout BigfootRandRead1thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/random-read-2thread-test.fio $LISTOFHOST
mv testout BigfootRandRead2thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/random-read-3thread-test.fio $LISTOFHOST
mv testout BigfootRandRead3thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/random-read-4thread-test.fio $LISTOFHOST
mv testout BigfootRandRead4thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/random-write-1thread-test.fio $LISTOFHOST
mv testout BigfootRandWrite1thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/random-write-2thread-test.fio $LISTOFHOST
mv testout BigfootRandWrite2thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/random-write-3thread-test.fio $LISTOFHOST
mv testout BigfootRandWrite3thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/random-write-4thread-test.fio $LISTOFHOST
mv testout BigfootRandWrite4thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-read-1thread-test.fio $LISTOFHOST
mv testout BigfootSeqRead1thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-read-2thread-test.fio $LISTOFHOST
mv testout BigfootSeqRead2thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-read-3thread-test.fio $LISTOFHOST
mv testout BigfootSeqRead3thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-read-4thread-test.fio $LISTOFHOST
mv testout BigfootSeqRead4thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-write-1thread-test.fio $LISTOFHOST
mv testout BigfootSeqWrite1thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-write-2thread-test.fio $LISTOFHOST
mv testout BigfootSeqWrite2thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-write-3thread-test.fio $LISTOFHOST
mv testout BigfootSeqWrite3thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-write-4thread-test.fio $LISTOFHOST
mv testout BigfootSeqWrite4thread$i
done

