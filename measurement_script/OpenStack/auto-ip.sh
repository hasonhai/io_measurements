#!/bin/bash

# Auto assign IP
nova floating-ip-list | grep -E '172.* - ' | cut -d'|' -f2 | sed 's/ //g' > iplist
nova list | grep "ACTIVE" | cut -d'|' -f2 | sed 's/ //g' > vmlist
paste -d, vmlist iplist > associate-fIP
for pair in $( cat associate-fIP )
do
    vmid="$( echo $pair | cut -d',' -f1 )"
    fIP="$( echo $pair | cut -d',' -f2 )"
    if [ "$vmid" = "" -o "$fIP" = "" ]; then
        echo "Floating IP or VMID is empty"
    else
        echo "Associate IP $fIP to VM ${vmid}..."
        nova floating-ip-associate "$vmid" "$fIP"
    fi
done
