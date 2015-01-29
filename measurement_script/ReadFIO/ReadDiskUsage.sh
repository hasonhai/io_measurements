#!/bin/bash

CURDIR=$( pwd )
RESULTDIR="$1"
cd $RESULTDIR
# Physical Machine
for PLATFORM in "OneVM" "TwoVM" "ThreeVM" "FourVM"; do #Remove Bigfoot bcuz results not available
#   echo "================$PLATFORM-Result=========================="
for TESTTYPE in "SeqRead" "SeqWrite" "RandRead" "RandWrite"; do
for NUMTHREAD in $( seq 4 ); do
for TESTNO in $( seq 5 ); do
    if [ -d $RESULTDIR/${PLATFORM}${TESTTYPE}${NUMTHREAD}thread0${TESTNO} ]; then
    cd $RESULTDIR/${PLATFORM}${TESTTYPE}${NUMTHREAD}thread0${TESTNO}
    # echo ${PLATFORM}${TESTTYPE}${NUMTHREAD}thread0${TESTNO}
    if [ "$TESTTYPE" = "SeqRead" -o "$TESTTYPE" = "RandRead" ]; then
        if [ "$PLATFORM" = "Bigfoot" ]; then
            DISKUSAGE=$( cat *.diskout | grep 131072 | cut -d';' -f6 --output-delimiter=' ' )
        else DISKUSAGE=$( cat *.diskout | grep 131072 | cut -d';' -f123 --output-delimiter=' ' )
        fi
    fi
    if  [ "$TESTTYPE" = "SeqWrite" -o "$TESTTYPE" = "RandWrite" ]; then
        if [ "$PLATFORM" = "Bigfoot" ]; then
            DISKUSAGE=$( cat *.diskout | grep 131072 | cut -d';' -f26 --output-delimiter=' ' )
        else DISKUSAGE=$( cat *.diskout | grep 131072 | cut -d';' -f123 --output-delimiter=' ' )
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
            dkusg=$(echo $DISKUSAGE | sed 's/ / NaN NaN NaN /g')
            dkusg="$dkusg NaN NaN NaN"
        elif [ "$NUMTHREAD" = "2" ]; then
            dkusg=$( echo $DISKUSAGE | sed 's/ / NaN NaN /2' )
            dkusg=$( echo $dkusg | sed 's/ / NaN NaN /6' )
            dkusg=$( echo $dkusg | sed 's/ / NaN NaN /10' )
            dkusg=$( echo $dkusg | sed 's/ / NaN NaN /14' )
            dkusg="$dkusg NaN NaN"
        elif [ "$NUMTHREAD" = "3" ]; then
            dkusg=$( echo $DISKUSAGE | sed 's/ / NaN /3' )
            dkusg=$( echo $dkusg | sed 's/ / NaN /7' )
            dkusg=$( echo $dkusg | sed 's/ / NaN /11' )
            dkusg=$( echo $dkusg | sed 's/ / NaN /15' )
            dkusg="$dkusg NaN"
        else
            dkusg=$( echo "$DISKUSAGE" | sed 's/ / /g' )
        fi
    else
        if [ "$PLATFORM" = "TwoVM" ]; then
            dkusg=$( echo $DISKUSAGE | sed 's/ / NaN NaN /2' )
            dkusg=$( echo $dkusg | sed 's/ / NaN NaN /6' )
            dkusg=$( echo $dkusg | sed 's/ / NaN NaN /10' )
            dkusg=$( echo $dkusg | sed 's/ / NaN NaN /14' )
            dkusg="$dkusg NaN NaN"
        elif [ "$PLATFORM" = "ThreeVM" ]; then
            dkusg=$( echo $DISKUSAGE | sed 's/ / NaN /3' )
            dkusg=$( echo $dkusg | sed 's/ / NaN /7' )
            dkusg=$( echo $dkusg | sed 's/ / NaN /11' )
            dkusg=$( echo $dkusg | sed 's/ / NaN /15' )
            dkusg="$dkusg NaN"
        else
            dkusg="$DISKUSAGE"
        fi
    fi      
    cd $RESULTDIR
    # echo -e "${AP}${P}TH${NUMTHREAD}T${TESTNO}\t${dkusg}"
    echo ${AP}${P}TH${NUMTHREAD}T${TESTNO} $dkusg
    fi
done
done
done
done
cd $CURDIR
