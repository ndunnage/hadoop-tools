#!/bin/bash
# Attach disks to Azure VMs
DiskSzie = 100 # Size in GBs
for i in $(cat hosts.txt)
do
 azure vm disk attach-new $i ${DiskSize}
done