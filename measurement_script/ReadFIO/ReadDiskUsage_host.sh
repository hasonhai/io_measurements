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
        if [ "$TESTTYPE" = "SeqRead" ]; then
            cat *.diskstat | grep "sd" | tail -n +3 | head -n -1 | awk '{ if ($6 > 100 ) print }' > dataclean.tmp
            DISKUSAGE=$( cat dataclean.tmp | grep "sd" | awk '{ sum += $NF; n++ } END { if (n > 0) print sum / n; }' )
            rm dataclean.tmp
        else
            cat *.diskstat | grep "sd" | tail -n +3 | head -n -1 > dataclean.tmp #remove first 3 lines and last 1 line
            DISKUSAGE=$( cat dataclean.tmp | grep "sd" | awk '{ sum += $NF; n++ } END { if (n > 0) print sum / n; }' )
            rm dataclean.tmp
        fi
        if [ "$DISKUSAGE" = "" ]; then
            DISKUSAGE=0
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
    echo ${AP}${P}TH${TH}T${TESTNO} $DISKUSAGE
    fi
done
done
done
done
cd $CURDIR
