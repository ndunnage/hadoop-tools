#!/bin/bash
# adddisk.sh
# Setup the storage disks
for i in $(cat hosts.txt)
do
	ssh -t $i "sudo bash -c su- \
	'echo "," | sfdisk /dev/sdc && mkfs.ext3 /dev/sdc1' && \
	'echo "/dev/sdc1 /data ext3 defaults 0 0" >> /etc/fstab' && \
	'mkdir /data' && \
	'mount /data'"
done