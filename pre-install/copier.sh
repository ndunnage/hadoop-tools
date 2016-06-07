#/bin/bash
# Copy the host files around
for hosts in {01..10}
do
tohostname=$(echo hostname$hosts".example.com")
echo $tohostname
scp /etc/hosts root@$tohostname:/etc/hosts
done

