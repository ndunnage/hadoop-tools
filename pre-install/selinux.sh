#!/bin/bash
# selinux.sh
# Disable Transparent Huge Pages and set swappiness
# set the command in /etc/rc.local
for i in $(cat hosts.txt)
do
        ssh -t $i "bash -c 'sed -i '\''s/SELINUX=enforcing/SELINUX=disabled/g'\'' /etc/selinux/config' && \
        'setenforce 0' "
done