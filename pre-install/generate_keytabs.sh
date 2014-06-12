#!/bin/bash
# generate_keytabs.sh
# Generates the generates the keytabes from hosts.txt
# When run on a properly configured KDC
[ -r "hostnames.txt" ] || {
	echo "File hostnames.txt doesn't exist"
	exit 1
}

# Set the name of the kerberos realm
krb_realm=HADOOP.LOCAL

for name in $(cat hostnames.txt);
	do
		install -o root -g root -m 0700 -d ${name}
		
		kadmin.local <<EOF
		addprinc -randkey host/${name}@${krb_realm}
		addprinc -randkey hdfs/${name}@${krb_realm}
		addprinc -randkey mapred/${name}@${krb_realm}
		ktadd -k ${name}/hdfs.keytab -norandkey \
			hdfs/${name}.${krb_realm} host/${name}@${krb_realm}
		ktadd -k ${name}/mapred.keytab -norandkey \
			mapred/${name}@${krb_realm} host/${name}@{krb_realm}
		EOF
	done
