#!/bin/bash
# changesudoers.sh
# Enables the azureuser to passwordless sudo
for i in $(cat hosts.txt)
do
	ssh -t $i "sudo bash -c 'echo \"azureuser ALL = (ALL) NOPASSWD: ALL\" > /etc/sudoers.d/waagent' && 'chmod 0440 /etc/sudoers.d/waagent'"
done