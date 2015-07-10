## Instructions for enabling FreeIPa 
Join all nodes in the cluster to IPA using sssd.
Install IPA client on the CM node.
Create a cloudera-scm account on the IPA, add it to the admin group and associate a non-expiring password policy with this account. (AFAIK IPA cannot currently create a non-expiring password policy, so I created a policy where the password expires in 5000 days).

Create a keytab file for the cloudera-scm account on the FreeIPA, be carefull about the default password policy with FreeIPA. Our admin account could be cloudera-manager for example. In order to generate the keytab one must first kinit as a user with Admin privilages in order to generate the Keytab. The keytab is used by the custom script /etc/cloudera-scm-server/gen_credentials_ipa.sh

```
kinit admin
```

shows the precise principal string for use when generating the keytab
```
ipa user-show cloudera-scm --all 
```

Create the keytab
```
ipa-getkeytab -s `hostname` -p cloudera-scm@BLANK.HADOOP.MMA.FR -k -p password /tmp/cloudera-scm.keytab
```

SCP the keytab onto the Cloudera Manager and place it in /etc/cloudera-scm-server/cloudera-scm.keytab
```
scp /tmp/cloudera-scm.keytab <cloudera-manager-hosts>:/etc/cloudera-scm-server/cloudera-scm.keytab
```

Make the owner cloudera-scm:cloudera-scm and permissions 600.
```
chown cloudera-scm:cloudera-scm /etc/cloudera-scm-server/cloudera-scm.keytab
```

If IPA is running on one of he nodes of the cluster, copy /etc/httpd/conf/ipa.keytab from the IPA server to the CM node file /etc/cloudera-scm-server/http.keytab. Change the ownership and protect this file also.
Copy the attached script to /etc/cloudera-scm-server/gen_credentials_ipa.sh on CM node, change the owner to cloudera-scm:cloudera-scm and permissions 700. Edit the script and change IPA_SERVER and REALM.
In CM enter Kerberos configuration for Kerberos realm, Custom Keytab retreival script (/etc/cloudera-scm-server/gen_credentials_ipa.sh) and enable Kerberos.