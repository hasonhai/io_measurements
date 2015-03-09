#!/bin/bash
ACCESSKEY="/home/sonhai/cloudbf12.pem"
USERNAME="ubuntu"
ONEVM="testdir/1vms.lst"
TWOVM="testdir/2vms.lst"
FOURVM="testdir/4vms.lst"
EIGHTVM="testdir/8vms.lst"
SIXTEENVM="testdir/16vms.lst"

for server in $( cat $SIXTEENVM );
do
   ssh -i $ACCESSKEY $USERNAME@$server 'PID=$( pidof server ); if [ "$PID" != "" ]; then kill $PID ; fi'
   scp -i $ACCESSKEY bcast/server $USERNAME@$server:
   ssh -i $ACCESSKEY $USERNAME@$server "nohup /home/ubuntu/server 3000 > server.out 2> server.err < /dev/null &"
done

for i in 01 02 03 04 05 06 07 08 09 10 ; do
time ./test_sshless.sh $ACCESSKEY $USERNAME testdir/sequential-read-1thread-test.fio $ONEVM
mv testout OneVMOneCoreSeqRead1thread$i
time ./test_sshless.sh $ACCESSKEY $USERNAME testdir/sequential-read-1thread-2vm-test.fio $TWOVM
mv testout TwoVMOneCoreSeqRead1thread$i
time ./test_sshless.sh $ACCESSKEY $USERNAME testdir/sequential-read-1thread-4vm-test.fio $FOURVM
mv testout FourVMOneCoreSeqRead1thread$i
time ./test_sshless.sh $ACCESSKEY $USERNAME testdir/sequential-read-1thread-8vm-test.fio $EIGHTVM
mv testout EightVMOneCoreSeqRead1thread$i
time ./test_sshless.sh $ACCESSKEY $USERNAME testdir/sequential-read-1thread-16vm-test.fio $SIXTEENVM
mv testout SixteenVMOneCoreSeqRead1thread$i
time ./test_sshless.sh $ACCESSKEY $USERNAME testdir/sequential-write-1thread-test.fio $ONEVM
mv testout OneVMOneCoreSeqWrite1thread$i
time ./test_sshless.sh $ACCESSKEY $USERNAME testdir/sequential-write-1thread-2vm-test.fio $TWOVM
mv testout TwoVMOneCoreSeqWrite1thread$i
time ./test_sshless.sh $ACCESSKEY $USERNAME testdir/sequential-write-1thread-4vm-test.fio $FOURVM
mv testout FourVMOneCoreSeqWrite1thread$i
time ./test_sshless.sh $ACCESSKEY $USERNAME testdir/sequential-write-1thread-8vm-test.fio $EIGHTVM
mv testout EightVMOneCoreSeqWrite1thread$i
time ./test_sshless.sh $ACCESSKEY $USERNAME testdir/sequential-write-1thread-16vm-test.fio $SIXTEENVM
mv testout SixteenVMOneCoreSeqWrite1thread$i
done


for server in $( cat $SIXTEENVM );
do
   ssh -i $ACCESSKEY $USERNAME@$server 'PID=$( pidof server ); echo $PID ; cat server.out; cat server.err'
done

echo 'Hi! The test is finished man!' | mail -s "Test is finished" hasonhai124@gmail.com
