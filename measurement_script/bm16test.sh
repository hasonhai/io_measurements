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

for i in 01; do
  for numthread in 1thread; do
    for accesspat in SeqRead; do

      if [ "$accesspat" = "SeqRead" ]; then fileconf="read"; fi
      if [ "$accesspat" = "SeqWrite" ]; then fileconf="write"; fi

      time ./test.sh $ACCESSKEY $USERNAME testdir/sequential-${fileconf}-${numthread}-test.fio $BFADD $DEVICE HOST
      mv usage.cpustat testout/Bigfoot${NumCore}Core${accesspat}${numthread}${i}.cpustat
      mv ${DEVICE}.diskstat testout/Bigfoot${NumCore}Core${accesspat}${numthread}${i}.diskstat
      mv testout Bigfoot${NumCore}Core${accesspat}${numthread}${i}

    done
  done
done

echo 'Hi, your test is finish!' | mail -s "Test is finish!" hasonhai124@gmail.com
