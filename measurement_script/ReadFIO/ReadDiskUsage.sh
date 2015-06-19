#!/bin/bash

CURDIR=$( pwd )
RESULTDIR="$1"
cd $RESULTDIR
# Physical Machine
for PLATFORM in "Bigfoot32Core" "Bigfoot16Core" "Bigfoot08Core" "Bigfoot04Core" "Bigfoot02Core" "Bigfoot01Core" "OneVMOneCore" "OneVMTwoCore" "OneVMFourCore" "OneVMEightCore" "OneVM16Core" "TwoVMOneCore" "FourVMOneCore" "EightVMOneCore" "SixteenVMOneCore"; do
#    echo "================$PLATFORM-Result=========================="
for TESTTYPE in "SeqRead" "SeqWrite"; do
for NUMTHREAD in 1 2 4 8 16; do
for TESTNO in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20; do
    if [ -d $RESULTDIR/${PLATFORM}${TESTTYPE}${NUMTHREAD}thread${TESTNO} ]; then
        cd $RESULTDIR/${PLATFORM}${TESTTYPE}${NUMTHREAD}thread${TESTNO}
        # echo ${PLATFORM}${TESTTYPE}${NUMTHREAD}thread0${TESTNO}
        if [ "$PLATFORM" = "Bigfoot32Core" ]; then
            DISKUSAGE=$( cat *.diskout | grep ';sequential' | cut -d';' -f139 --output-delimiter=' ' )
        else
            DISKUSAGE=$( cat *.diskout | grep ';sequential' | cut -d';' -f130 --output-delimiter=' ' )
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
        Bigfoot16Core) P="BF16C";;
        Bigfoot08Core) P="BF08C";;
        Bigfoot04Core) P="BF04C";;
        Bigfoot02Core) P="BF02C";;
        Bigfoot01Core) P="BF01C";;
        *) P="Unknown";;
    esac
    
    case $TESTTYPE in
        SeqRead) AP="SR";;
        SeqWrite) AP="SW";;
        *) P="Unknown";;
    esac

    if [ "$PLATFORM" = "Bigfoot32Core" -o "$PLATFORM" = "Bigfoot16Core" -o "$PLATFORM" = "Bigfoot08Core" -o "$PLATFORM" = "Bigfoot04Core" -o "$PLATFORM" = "Bigfoot02Core" -o "$PLATFORM" = "Bigfoot01Core" -o "$PLATFORM" = "OneVMOneCore" -o "$PLATFORM" = "OneVMTwoCore" -o "$PLATFORM" = "OneVMFourCore" -o "$PLATFORM" = "OneVMEightCore" -o "$PLATFORM" = "OneVM16Core" ]; then
        if [ "$NUMTHREAD" = "1" ]; then
            du="$DISKUSAGE NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN"
        elif [ "$NUMTHREAD" = "2" ]; then
            du="$DISKUSAGE NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN"
        elif [ "$NUMTHREAD" = "4" ]; then
            du="$DISKUSAGE NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN"
        elif [ "$NUMTHREAD" = "8" ]; then
            du="$DISKUSAGE NaN NaN NaN NaN NaN NaN NaN NaN"
        elif [ "$NUMTHREAD" = "16" ]; then
            du="$DISKUSAGE"
        fi
    else
        if [ "$PLATFORM" = "TwoVMOneCore" ]; then
            du="$DISKUSAGE NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN"
        elif [ "$PLATFORM" = "FourVMOneCore" ]; then
            du="$DISKUSAGE NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN"
        elif [ "$PLATFORM" = "EightVMOneCore" ]; then
            du="$DISKUSAGE NaN NaN NaN NaN NaN NaN NaN NaN"
        elif [ "$PLATFORM" = "SixteenVMOneCore" ]; then
            du="$DISKUSAGE"
        fi
    fi      
    cd $RESULTDIR
    # echo -e "${AP}${P}TH${NUMTHREAD}T${TESTNO}\t${du}"
    # Convert NUMTHREAD to same number of digit
    case $NUMTHREAD in
        1) TH="01";;
        2) TH="02";;
        4) TH="04";;
        8) TH="08";;
        16) TH="16";;
        *) P="Unknown";;
    esac
    echo ${AP}${P}TH${TH}T${TESTNO} $du
    fi
done
done
done
done
cd $CURDIR
