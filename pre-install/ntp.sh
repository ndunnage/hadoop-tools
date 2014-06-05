#!/bin/bash
# ntp.sh
# Transparent Huge Pages
# set the command in /etc/rc.local
for i in $(cat host.txt)
do
	ssh -t $i "bash -c \
	'echo server prod-r01-m31.hadoop.local >> /etc/ntp.conf' && \
	'/etc/init.d/ntpd start < /dev/null > /tmp/ntpdstart.log 2>&1 &' "
done
