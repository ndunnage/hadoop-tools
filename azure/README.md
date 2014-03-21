## Build the Azure virtual machines
Use the CreateAzureVMs.sh to create the Virtual Machines. Update the hosts.txt with the machines you require

To see a list of available images:

```
azure vm image list
```

To spawn the machines run:

```
cd azure
./CreateAzureVMs.sh
``` 

The machines typically take a couple of minutes to spawn. Check via https://manage.windowsazure.com

Once done so attach the storage using AttachAzureStorage.sh ensuring you have create the storage account

```
./AttacheAzureStorage.sh
``` 

### Post machine creation tasks
Some of the remaining installation tasks require root access to the nodes. To do this you need to change the configuration created by the Windows Azure Agent at first boot to ensure our azureuser can sudo as root. To do this you need to copy the post install scripts over to the admin node. Which is the first virtual machine created.

```
./copyToAdminNode.sh
``` 

This will copy all of the cluster maintenence scripts over to the admin node which typically is the first entry in the hosts.txt


### Admin node tasks
run the changesudoers.sh:

```
./changesudoers.sh
``` 

With passwordless access you can now format and mount the storage using the adddisk.sh:

```
./adddisk.sh
``` 

## Setup Internal DNS
The next task is to configure DNS in order that each node has a fully qualified domain name. First setup bind on the admin server

```
sudo apt-get install bind
```

edit named.conf.local to add the zone files

```
sudo vi /etc/bind/named.local.conf
```

Copy these values in:

```
This is an internal only zone

zone "internal" {
        type master;
        file "/etc/bind/zones/db.internal";
};

zone "0.0.10.in-addr.arpa" {
        type master;
        file "/etc/bind/zones/db.0.0.10.in-addr.arpa";
};
```

You then need to edit each zone file to incorporate the list of hosts in the host.txt. The first entry is the admin server and acts as the name server.

```
cp /etc/bind/db.empty /etc/bind/zones/db.internal
vi  /etc/bind/db.empty 
```

Edit the file to add the A records of the hosts you created in host.txt

```
@       IN      SOA     localhost. root.localhost. (
                              1         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                          86400 )       ; Negative Cache TTL
;
@       IN      NS      ns.internal.
ns      IN      A       10.0.0.4
cdh-hostname1   IN      A       10.0.0.4
```

Similarly do the same for the reverse zone:

```
cp /etc/bind/db.empty /etc/bind/zones/db.internal
vi  /etc/bind/zones/db.0.0.10.in-addr.arpa
```

 Edit it to look like this:

```
 $TTL    86400
@       IN      SOA     localhost. root.localhost. (
                              1         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                          86400 )       ; Negative Cache TTL
;
@       IN      NS      ns.internal.
4   IN      PTR     cdh-hostname1.internal.
```

Once you've created you're zone files restart Bind and test using nslookup. You will need to ensure that each host is resoling using the nameserver and search on the internal domain. The resolv.sh script can deploy the changes. Run from the same directory as hosts.txt

```
sudo service bind9 restart
nslookup cdh-hostname1
```
 A userful check is to run hostname on each of the nodes:

```
hostname && hostname -f
```

Assuming you've done this correctly you should now be ready to install the Cloudera Manager on the Admin machine

```
wget http://archive.cloudera.com/cm4/installer/latest/cloudera-manager-installer.bin
chmod +x ./cloudera-manager-installer.bin
sudo ./cloudera-manager-installer.bin
```

