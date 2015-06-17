#!/bin/bash
# To test the script for disk test
# test.sh <key> <username> <conf> <hostlist> <device>

HOSTLIST=$( cat $4 )
KEY=$1
USER=$2
CONF=$3

if [ $5 ]; then
    echo "Disk utilization recoder is enable on $5"
    DEVICE=$5
fi

if [ $6 ]; then
    echo "CPU utilization recoder is enable on $6"
    if [ "$6" = "VM" ]; then
        TRACK_PROCESS="qemu-system-x86" # for VM
    else
        TRACK_PROCESS="fio" # for host
    fi
fi


chmod a+x disktest.sh
echo "Setup the host"
for HOST in $HOSTLIST; do
    ./disktest.sh $CONF $USER $KEY $HOST setup-host
done

echo "Setup the test"
for HOST in $HOSTLIST; do
    ./disktest.sh $CONF $USER $KEY $HOST setup-test
done

# Run measurement in parallel on host
echo "Running the test"
if [ $5 ]; then
    echo 'Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util' > ${DEVICE}.diskstat
    iostat -dx 1 | grep "$DEVICE" >> ${DEVICE}.diskstat &
    iostat_id=$( jobs -p %1 )
    echo iostat ID is ${iostat_id}
fi
# error with bare metal because fio haven't start before grep its pid, maybe move to after disktest run 
if [ "$6" = "VM" ]; then
    echo Run top to collect CPU utilization on $6    
    echo '  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND' > usage.cpustat
    top -p $(pgrep -d',' "$TRACK_PROCESS") -d 1 -b | grep "$TRACK_PROCESS" >> usage.cpustat &
    top_id=$( jobs -p %2 )
    echo top ID is ${top_id}
fi

for HOST in $HOSTLIST; do
    ./disktest.sh $CONF $USER $KEY $HOST run &
done

if [ "$6" = "HOST" ]; then
    sleep 3
    echo Run top to collect CPU utilization on $6  
    echo '  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND' > usage.cpustat
    top -p $(pgrep -d',' "$TRACK_PROCESS") -d 1 -b | grep "$TRACK_PROCESS" >> usage.cpustat &
    for job in `jobs -p`; do top_id=$job; done
    echo top ID is ${top_id}
fi

# Wait for all hosts to complete
FAIL=0
for job in `jobs -p`
do
    if [ "$DEVICE" != "" -a \( "$job" = "${iostat_id}" -o "$job" = "${top_id}" \) ]; then
        echo "not wait for recoder process"
        continue
    fi
    echo "wait for process $job to finish"
    wait $job || let "FAIL+=1"
done

if [ "$FAIL" == "0" ];
then
    echo "Tests ran well"
else
    echo "Notice: ($FAIL) Failed test(s)"
fi

if [ $5 ]; then
    echo "Shutdown the disk utilization recorder"
    kill $iostat_id && echo "iostat stop ... OK"
fi

if [ $6 ]; then
    echo "Shutdown the CPU utilization recorder"
    kill $top_id && echo "top stop ... OK" 
fi

echo "Collecting test output"
for HOST in $HOSTLIST; do
    ./disktest.sh $CONF $USER $KEY $HOST collect-data
done

echo "Clean the host"
for HOST in $HOSTLIST; do
    ./disktest.sh $CONF $USER $KEY $HOST clean
done
