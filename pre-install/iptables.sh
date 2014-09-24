#!/bin/bash
# iptables.sh
# Disable Transparent Huge Pages and set swappiness
# set the command in /etc/rc.local
for i in $(cat hosts.txt)
do
        ssh -t $i "bash -c 'service iptables stop' && \
        'chkconfig iptables off' && \
        'service ip6tables stop' && \
        'chkconfig ip6tables off' "
done