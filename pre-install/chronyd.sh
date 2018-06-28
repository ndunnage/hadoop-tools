#!/bin/bash
# chronyd.sh
# Synchronise time accross all hosts in the cluster
# Replace the pool server with a LAN based slave
for i in $(cat hosts.txt)
do
	ssh -t $i "bash -c \
	'sudo echo server somechrony.timeserver.com iburst >> /etc/chrony.conf' && \
	'sudo service chronyd restart < /dev/null > /tmp/chronydstart.log 2>&1 &' "
done