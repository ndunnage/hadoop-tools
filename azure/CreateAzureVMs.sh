#!/bin/bash
# Create the hosts
# This script will read in a list of hosts contained in hosts.txt
# A passwordless Azure user is created for shell access
hosts = "hosts.txt"
VM_Network = <virtual-network-name>
Subnet = Subnet-1
Affintity_Group=<affinitygroup>
VM_Size = <instancesize>
OSID = <OS id> ## eg b39f27a8b8c64d52b05eac6a62ebad85__Ubuntu-12_04_3-LTS-amd64-server-20140130-en-us-30GB
Username = <username>
Password = 'Pa$$w0rd1'
Ssh_Port = 22 # typically 22, a webservice end point is automatically created
Ssh_Cert = <"ssh certificate location"> # eg /dir/MyCert.pem

### Build the instances reading hostnames in from hosts.txt
for i in $(cat ${hosts})
do
	azure vm create \
--virtual-network-name ${VM_Network} \
--subnet-names ${Subnet} \ 
--affinity-group ${Affintity_Group} \
--vm-size ${VM_Size} \
--ssh ${Ssh_Port} \
--ssh-cert ${Ssh_Cert} \
$i ${OSID} ${Username} ${Password} \
done