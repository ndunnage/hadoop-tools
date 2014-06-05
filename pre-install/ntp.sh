#!/bin/bash
# ntp.sh
# Synchronise time accross all hosts in the cluster
# Replace the pool server with a LAN based slave
for i in $(cat hosts.txt)
do
	ssh -t $i "bash -c \
	'echo server 0.europe.pool.ntp.org >> /etc/ntp.conf' && \
	'/etc/init.d/ntpd start < /dev/null > /tmp/ntpdstart.log 2>&1 &' "
done
