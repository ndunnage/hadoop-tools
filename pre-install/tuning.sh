#!/bin/bash
# tuning.sh
# Disable Transparent Huge Pages and set swappiness
# set the command in /etc/rc.local
for i in $(cat hosts.txt)
do
        ssh -t $i "bash -c 'echo \"never\" > /sys/kernel/mm/redhat_transparent_hugepage/defrag' && \
        'sysctl -w vm.swappiness=0' "
done