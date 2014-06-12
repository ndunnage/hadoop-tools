#!/bin/bash
# key_copier.sh
export CLUSTER="node01 node02 node03 node04 node05 node06 node07 node08 node09 node10"
function cluster { 
	for i in $CLUSTER;
	 do echo "***${i}***";
	  ssh -t -i ~/.ssh/id_rsa $i "${1}";
	  done;
	   }