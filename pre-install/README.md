## Pre-install scripts for Centos 6.x

A selection of scripts for preparing Centos prior to cluster installation. These are targeted at physical hardware, however can be amended to work with Azure storage volumes

The scripts use a for loop to execute against each host in hosts.txt

1. Tuning

Disable transparent huge pages and set kernel swappiness to O

```
./tuning.sh
``` 

2. Synchronise time across the cluster

```
./ntp.sh
``` 

3. Format and mount hard disks in JBOD format

This script executes a for loop to copy the contents of the diskformat.sh to every host listed in hosts.txt and excute the copied script on the target host. The Diskformat script will format format and mount 10 disks per hosts in JBOD configuration. Amend as required

```
./distributer.sh
``` 