#!/bin/bash
# To test the script for disk test
# test.sh <key> <username> <conf> <hostlist>

HOSTLIST=$( cat $4 )
KEY=$1
USER=$2
CONF=$3

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
for HOST in $HOSTLIST; do
    ./disktest.sh $CONF $USER $KEY $HOST run &
done

# Wait for all hosts to complete
FAIL=0
for job in `jobs -p`
do
    wait $job || let "FAIL+=1"
done

if [ "$FAIL" == "0" ];
then
    echo "Tests ran well"
else
    echo "Notice: ($FAIL) Failed test(s)"
fi

echo "Collecting test output"
for HOST in $HOSTLIST; do
    ./disktest.sh $CONF $USER $KEY $HOST collect-data
done

echo "Clean the host"
for HOST in $HOSTLIST; do
    ./disktest.sh $CONF $USER $KEY $HOST clean
done
