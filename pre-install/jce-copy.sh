#/bin/bash
# Copy the krb5.conf and jce policy files around
for hosts in {001..009}
do
tohostname=$(echo hostname$hosts"example.com")
echo $tohostname
scp /etc/krb5.conf root@$tohostname:/etc/krb5.conf
ssh $tohostname 'cp /usr/java/jdk1.7.0_79/jre/lib/security/local_policy.jar /usr/java/jdk1.7.0_79/jre/lib/security/local_policy.jar.orig ; cp /usr/java/jdk1.7.0_79/jre/lib/security/US_export_policy.jar /usr/java/jdk1.7.0_79/jre/lib/security/US_export_policy.jar.orig'
scp /usr/java/jdk1.7.0_75/jre/lib/security/local_policy.jar root@$tohostname:/usr/java/jdk1.7.0_79/jre/lib/security/local_policy.jar
scp /usr/java/jdk1.7.0_75/jre/lib/security/US_export_policy.jar root@$tohostname:/usr/java/jdk1.7.0_79/jre/lib/security/US_export_policy.jar
done
