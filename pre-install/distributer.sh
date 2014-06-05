#!/bin/bash
# Copies and executes the diskformater.sh to every host
SCRIPT=diskformater.sh
Disk_Config=$(cat $SCRIPT)
for i in $(cat hosts.txt)

do
ssh -t $i  "bash -c \
'echo  \"$Disk_Config\" > diskformater.sh && chmod +x diskformater.sh' " 
done