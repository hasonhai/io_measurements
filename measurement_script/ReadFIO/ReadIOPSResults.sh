#!/bin/bash

CURDIR=$( pwd )
RESULTDIR="$1"
cd $RESULTDIR
# Physical Machine
for PLATFORM in "Bigfoot" "OneVM" "TwoVM" "ThreeVM" "FourVM"; do
#    echo "================$PLATFORM-Result=========================="
for TESTTYPE in "SeqRead" "SeqWrite" "RandRead" "RandWrite"; do
for NUMTHREAD in $( seq 4 ); do
for TESTNO in $( seq 5 ); do
    if [ -d $RESULTDIR/${PLATFORM}${TESTTYPE}${NUMTHREAD}thread0${TESTNO} ]; then
    cd $RESULTDIR/${PLATFORM}${TESTTYPE}${NUMTHREAD}thread0${TESTNO}
    # echo ${PLATFORM}${TESTTYPE}${NUMTHREAD}thread0${TESTNO}
    if [ "$TESTTYPE" = "SeqRead" -o "$TESTTYPE" = "RandRead" ]; then
        if [ "$PLATFORM" = "Bigfoot" ]; then
            IOPSECOND=$( cat *.diskout | grep 131072 | cut -d';' -f7 --output-delimiter=' ' )
        else IOPSECOND=$( cat *.diskout | grep 131072 | cut -d';' -f8 --output-delimiter=' ' )
        fi
    fi
    if  [ "$TESTTYPE" = "SeqWrite" -o "$TESTTYPE" = "RandWrite" ]; then
        if [ "$PLATFORM" = "Bigfoot" ]; then
            IOPSECOND=$( cat *.diskout | grep 131072 | cut -d';' -f27 --output-delimiter=' ' )
        else IOPSECOND=$( cat *.diskout | grep 131072 | cut -d';' -f49 --output-delimiter=' ' )
        fi
    fi
    
    if [ "$PLATFORM" = "TwoVM" ]; then
        P="2VM"
    elif [ "$PLATFORM" = "ThreeVM" ]; then
        P="3VM"
    elif [ "$PLATFORM" = "FourVM" ]; then
        P="4VM"
    elif [ "$PLATFORM" = "Bigfoot" ]; then
        P="BF"
    elif [ "$PLATFORM" = "OneVM" ]; then
        P="1VM"
    else P="Unknown"
    fi

    if [ "$TESTTYPE" = "SeqRead" ]; then
        AP="SR"
    elif [ "$TESTTYPE" = "SeqWrite" ]; then
        AP="SW"
    elif [ "$TESTTYPE" = "RandRead" ]; then
        AP="RR"
    elif [ "$TESTTYPE" = "RandWrite" ]; then
        AP="RW"
    else P="Unknown"
    fi

    if [ "$PLATFORM" = "Bigfoot" -o "$PLATFORM" = "OneVM" ]; then
        if [ "$NUMTHREAD" = "1" ]; then
            iops=$(echo $IOPSECOND | sed 's/ / NaN NaN NaN /g')
            iops="$iops NaN NaN NaN"
        elif [ "$NUMTHREAD" = "2" ]; then
            iops=$( echo $IOPSECOND | sed 's/ / NaN NaN /2' )
            iops=$( echo $iops | sed 's/ / NaN NaN /6' )
            iops=$( echo $iops | sed 's/ / NaN NaN /10' )
            iops=$( echo $iops | sed 's/ / NaN NaN /14' )
            iops="$iops NaN NaN"
        elif [ "$NUMTHREAD" = "3" ]; then
            iops=$( echo $IOPSECOND | sed 's/ / NaN /3' )
            iops=$( echo $iops | sed 's/ / NaN /7' )
            iops=$( echo $iops | sed 's/ / NaN /11' )
            iops=$( echo $iops | sed 's/ / NaN /15' )
            iops="$iops NaN"
        else
            iops=$( echo "$IOPSECOND" | sed 's/ / /g' )
        fi
    else
        if [ "$PLATFORM" = "TwoVM" ]; then
            iops=$( echo $IOPSECOND | sed 's/ / NaN NaN /2' )
            iops=$( echo $iops | sed 's/ / NaN NaN /6' )
            iops=$( echo $iops | sed 's/ / NaN NaN /10' )
            iops=$( echo $iops | sed 's/ / NaN NaN /14' )
            iops="$iops NaN NaN"
        elif [ "$PLATFORM" = "ThreeVM" ]; then
            iops=$( echo $IOPSECOND | sed 's/ / NaN /3' )
            iops=$( echo $iops | sed 's/ / NaN /7' )
            iops=$( echo $iops | sed 's/ / NaN /11' )
            iops=$( echo $iops | sed 's/ / NaN /15' )
            iops="$iops NaN"
        else
            iops="$IOPSECOND"
        fi
    fi      
    cd $RESULTDIR
    # echo -e "${AP}${P}TH${NUMTHREAD}T${TESTNO}\t${iops}"
    echo ${AP}${P}TH${NUMTHREAD}T${TESTNO} $iops
    fi
done
done
done
done
cd $CURDIR
