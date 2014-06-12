#!/bin/bash
# generate_hosts.sh
# Generates a host.txt file
for n in $(seq -f "%02g" 1 10) ;
	do
		echo "hadoop${n}.hadoop.local"
	done