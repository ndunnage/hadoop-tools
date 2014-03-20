#!/bin/bash
# copyToAdminNode.sh
# Copy all maintenance scripts to the admin node
admin_host=$(head -n 1 hosts.txt)
domain="cloudapp.net"
user="azureuser"
connection="${user}@${admin_host}.${domain}"

scp -i adddisk.sh changesudoers.sh resolv.sh hosts.txt ${connection}:/
echo "Copied all admin scripts"