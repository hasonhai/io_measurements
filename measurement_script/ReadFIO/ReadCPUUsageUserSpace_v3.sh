#!/bin/bash

CURDIR=$( pwd )
RESULTDIR="$1"
cd $RESULTDIR
# Physical Machine
for PLATFORM in "Bigfoot32Core" "OneVMOneCore" "OneVMTwoCore" "OneVMFourCore" "OneVMEightCore" "OneVM16Core" "TwoVMOneCore" "FourVMOneCore" "EightVMOneCore" "SixteenVMOneCore"; do
#    echo "================$PLATFORM-Result=========================="
for TESTTYPE in "SeqRead" "SeqWrite"; do
for NUMTHREAD in 1 2 4 8 16; do
for TESTNO in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20; do
    if [ -d $RESULTDIR/${PLATFORM}${TESTTYPE}${NUMTHREAD}thread${TESTNO} ]; then
        cd $RESULTDIR/${PLATFORM}${TESTTYPE}${NUMTHREAD}thread${TESTNO}
        # echo ${PLATFORM}${TESTTYPE}${NUMTHREAD}thread${TESTNO}
        if [ "$TESTTYPE" = "SeqRead" ]; then
            CPUUS=$( cat *.diskout | grep ';sequentialread;' | cut -d';' -f88 --output-delimiter=' ' )
        fi
        if [ "$TESTTYPE" = "SeqWrite" ]; then
            CPUUS=$( cat *.diskout | grep ';sequentialwrite;' | cut -d';' -f88 --output-delimiter=' ' )
        fi

    case $PLATFORM in
        OneVMOneCore) P="01VM01C";;
        OneVMTwoCore) P="01VM02C";;
        OneVMFourCore) P="01VM04C";;
        OneVMEightCore) P="01VM08C";;
        OneVM16Core) P="01VM16C";;
        TwoVMOneCore) P="02VM01C";;
        FourVMOneCore) P="04VM01C";;
        EightVMOneCore) P="08VM01C";;
        SixteenVMOneCore) P="16VM01C";;
        Bigfoot32Core) P="BF32C";;
        *) P="Unknown";;
    esac
    
    case $TESTTYPE in
        SeqRead) AP="SR";;
        SeqWrite) AP="SW";;
        *) P="Unknown";;
    esac

    if [ "$PLATFORM" = "Bigfoot32Core" -o "$PLATFORM" = "OneVMOneCore" -o "$PLATFORM" = "OneVMTwoCore" -o "$PLATFORM" = "OneVMFourCore" -o "$PLATFORM" = "OneVMEightCore" -o "$PLATFORM" = "OneVM16Core" ]; then
        if [ "$NUMTHREAD" = "1" ]; then
            cpuus="$CPUUS NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN"
        elif [ "$NUMTHREAD" = "2" ]; then
            cpuus="$CPUUS NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN"
        elif [ "$NUMTHREAD" = "4" ]; then
            cpuus="$CPUUS NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN"
        elif [ "$NUMTHREAD" = "8" ]; then
            cpuus="$CPUUS NaN NaN NaN NaN NaN NaN NaN NaN"
        elif [ "$NUMTHREAD" = "16" ]; then
            cpuus="$CPUUS"
        fi
    else
        if [ "$PLATFORM" = "TwoVMOneCore" ]; then
            cpuus="$CPUUS NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN"
        elif [ "$PLATFORM" = "FourVMOneCore" ]; then
            cpuus="$CPUUS NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN"
        elif [ "$PLATFORM" = "EightVMOneCore" ]; then
            cpuus="$CPUUS NaN NaN NaN NaN NaN NaN NaN NaN"
        elif [ "$PLATFORM" = "SixteenVMOneCore" ]; then
            cpuus="$CPUUS"
        fi
    fi      
    cd $RESULTDIR
    # echo -e "${AP}${P}TH${NUMTHREAD}T${TESTNO}\t${cpuus}"
        # Convert NUMTHREAD to same number of digit
    case $NUMTHREAD in
        1) TH="01";;
        2) TH="02";;
        4) TH="04";;
        8) TH="08";;
        16) TH="16";;
        *) P="Unknown";;
    esac

    echo ${AP}${P}TH${TH}T${TESTNO} $cpuus
    fi
done
done
done
done
cd $CURDIR
