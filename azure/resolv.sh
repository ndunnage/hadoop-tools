#!/bin/bash
# Update resolv.conf on each host to use the nameserver and search domain
for i in $(cat hosts.txt)
do
        ssh -t cdh-$i "sudo bash -c 'echo \"nameserver	10.0.0.4\nsearch internal\" >> /etc/resolv.conf'"
done