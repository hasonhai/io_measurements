#!/bin/bash
# Run disk test on a single machine

CONF="$1"  # config file for fio
USER="$2"  # user to run test
KEY="$3"   # key to access target host
TARGET="$4" # IP or hostname of target host (prefer IP)
COMMAND="$5"
if [ $6 ]; then
    OS="$6"
else
    OS="Ubuntu" #Default OS
fi

function usage(){
  echo "./disktest.sh <conf> <user> <key> <host> <command>"
  echo "    Command could be:"
  echo "        * setup-host:   to set-up the host"
  echo "        * setup-test:   to prepare the test"
  echo "        * run:          run test on host"
  echo "        * collect-data: collect the data"
  echo "        * clean:        clean the host"
}

CONFNAME="$( basename $CONF )"
TestDir="$(grep 'directory=' $CONF | awk -F"=" '{print $2}')"
if [ "$TestDir" = "" ]; then
    echo "Test directory for Fio is not set!"
    exit 1
fi

if [ "$COMMAND" = "setup-host" ]; then
    # Setup host only
    ssh -i $KEY $USER@$TARGET "mkdir ~/MrBentest"
    ssh -i $KEY $USER@$TARGET "mkdir ~/diskout"
    FIOCHECK="$(ssh -i $KEY $USER@$TARGET "which fio")"
    if [ "$FIOCHECK" = "" ]; then
        echo "Could not find fio! We are going to install FIO now!"
        if [ "$OS" = "Ubuntu" ]; then
            scp -i $KEY InstallFIOUbuntu.sh $USER@$TARGET:
            ssh -tt -i $KEY $USER@$TARGET "chmod a+x InstallFIOUbuntu.sh && sudo ./InstallFIOUbuntu.sh"
        elif [ "$OS" = "CentOS" ]; then
            scp -i $KEY InstallFIOCentos.sh $USER@$TARGET:
            ssh -tt -i $KEY $USER@$TARGET "chmod a+x InstallFIOCentos.sh && sudo ./InstallFIOCentos.sh"
        fi
    else
        echo "Found FIO at $FIOCHECK"
        echo "$TARGET is ready, we are setting up the environment"
    fi
    scp -i $KEY targetrun.sh $USER@$TARGET:~/MrBentest/targetrun.sh
    ssh -i $KEY $USER@$TARGET "chmod a+x ~/MrBentest/targetrun.sh"
    ssh -i $KEY $USER@$TARGET "echo 1 > ~/MrBentest/.setuphost"
elif [ "$COMMAND" = "setup-test" ]; then
    # Setup host to for each test
    echo "Config file: $CONFNAME"
    echo "FIO test directory: $TestDir"
    SETUPDONE="$(ssh -i $KEY $USER@$TARGET 'cat ~/MrBentest/.setuphost')"
    if [ $SETUPDONE -eq 1 ]; then
        scp -i $KEY $CONF $USER@$TARGET:~/MrBentest/$CONFNAME
        ssh -i $KEY $USER@$TARGET "mkdir -p $TestDir" # be careful with this one
        ssh -i $KEY $USER@$TARGET "echo 1 > ~/MrBentest/.setuptest"
    fi
elif [ "$COMMAND" = "run" ]; then
    # Running test
    # SETUPDONE="$(ssh -i $KEY $USER@$TARGET 'cat ~/MrBentest/.setuptest')"
    # if [ $SETUPDONE -eq 1 ]; then
        echo "Running test on $TARGET"
        ssh -tt -i $KEY $USER@$TARGET "sh ~/MrBentest/targetrun.sh MrBentest/$CONFNAME $TestDir"
    # else
    #    echo "Please setup host first"
    #    exit 1
    # fi
elif [ "$COMMAND" = "collect-data" ]; then
    if [ ! -d "testout" ]; then
        mkdir testout
    fi
    echo "Collect test result"
    scp -i $KEY $USER@$TARGET:~/diskout/*.diskout testout/    
elif [ "$COMMAND" = "clean" ]; then
    SETUPDONE="$(ssh -i $KEY $USER@$TARGET 'cat ~/MrBentest/.setuphost')"
    if [ $SETUPDONE -eq 1  ]; then
        echo "Removing temporary directory"
        ssh -i $KEY $USER@$TARGET "rm -rf ~/MrBentest"
        echo "Removing test output on host $TARGET"
        ssh -i $KEY $USER@$TARGET "rm -rf ~/diskout"
        ssh -i $KEY $USER@$TARGET "rm -rf $TestDir"
    fi
else
    usage
    exit 1
fi
