#!/bin/bash
ACCESSKEY="/home/sonhai/cloudbf12.pem"
USERNAME="ubuntu"
#ONEVM="testdir/1vms.lst"
TWOVM="testdir/2vms.lst"
FOURVM="testdir/4vms.lst"
EIGHTVM="testdir/8vms.lst"
SIXTEENVM="testdir/16vms.lst"
VMSPEC=OneCore
DEVICE=sda

for server in $( cat $SIXTEENVM );
do
   ssh -i $ACCESSKEY $USERNAME@$server 'PID=$( pidof server ); if [ "$PID" != "" ]; then kill $PID ; fi'
   scp -i $ACCESSKEY bcast/server $USERNAME@$server:
   ssh -i $ACCESSKEY $USERNAME@$server "nohup /home/ubuntu/server 3000 > server.out 2> server.err < /dev/null &"
done

for i in 01 02 03 04 05 ; do

time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-read-1thread-2vm-test.fio $TWOVM $DEVICE VM SSHLESS
mv ${DEVICE}.diskstat testout/TwoVM${VMSPEC}SeqRead1thread${i}.diskstat
mv usage.cpustat testout/TwoVM${VMSPEC}SeqRead1thread${i}.cpustat
mv testout TwoVMOneCoreSeqRead1thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-read-1thread-4vm-test.fio $FOURVM $DEVICE VM SSHLESS
mv ${DEVICE}.diskstat testout/FourVM${VMSPEC}SeqRead1thread${i}.diskstat
mv usage.cpustat testout/FourVM${VMSPEC}SeqRead1thread${i}.cpustat
mv testout FourVMOneCoreSeqRead1thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-read-1thread-8vm-test.fio $EIGHTVM $DEVICE VM SSHLESS
mv ${DEVICE}.diskstat testout/EightVM${VMSPEC}SeqRead1thread${i}.diskstat
mv usage.cpustat testout/EightVM${VMSPEC}SeqRead1thread${i}.cpustat
mv testout EightVMOneCoreSeqRead1thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-read-1thread-16vm-test.fio $SIXTEENVM $DEVICE VM SSHLESS
mv ${DEVICE}.diskstat testout/SixteenVM${VMSPEC}SeqRead1thread${i}.diskstat
mv usage.cpustat testout/SixteenVM${VMSPEC}SeqRead1thread${i}.cpustat
mv testout SixteenVMOneCoreSeqRead1thread$i

time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-write-1thread-2vm-test.fio $TWOVM $DEVICE VM SSHLESS
mv ${DEVICE}.diskstat testout/TwoVM${VMSPEC}SeqRead1thread${i}.diskstat
mv usage.cpustat testout/TwoVM${VMSPEC}SeqRead1thread${i}.cpustat
mv testout TwoVMOneCoreSeqWrite1thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-write-1thread-4vm-test.fio $FOURVM $DEVICE VM SSHLESS
mv ${DEVICE}.diskstat testout/FourVM${VMSPEC}SeqRead1thread${i}.diskstat
mv usage.cpustat testout/FourVM${VMSPEC}SeqRead1thread${i}.cpustat
mv testout FourVMOneCoreSeqWrite1thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-write-1thread-8vm-test.fio $EIGHTVM $DEVICE VM SSHLESS
mv ${DEVICE}.diskstat testout/EightVM${VMSPEC}SeqRead1thread${i}.diskstat
mv usage.cpustat testout/EightVM${VMSPEC}SeqRead1thread${i}.cpustat
mv testout EightVMOneCoreSeqWrite1thread$i
time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-write-1thread-16vm-test.fio $SIXTEENVM $DEVICE VM SSHLESS
mv ${DEVICE}.diskstat testout/SixteenVM${VMSPEC}SeqRead1thread${i}.diskstat
mv usage.cpustat testout/SixteenVM${VMSPEC}SeqRead1thread${i}.cpustat
mv testout SixteenVMOneCoreSeqWrite1thread$i

done


for server in $( cat $SIXTEENVM );
do
   ssh -i $ACCESSKEY $USERNAME@$server 'PID=$( pidof server ); echo $PID ; cat server.out; cat server.err'
done

echo 'Hi! The test is finished man!' | mail -s "Test is finished" hasonhai124@gmail.com
