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

The next task is to configure DNS in order that each node has a fully qualified domain name. First setup bind on the admin server

```
sudo apt-get install bind
```

edit named.conf.local to add the zone files

```
sudo vi /etc/bind/named.local.conf
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
