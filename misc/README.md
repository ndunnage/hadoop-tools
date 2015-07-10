## MySQL Installtion for Cloudera Enterprise Cluster
Documentation http://www.cloudera.com/content/cloudera/en/documentation/core/latest/topics/cm_ig_mysql.html

Secure the MySQL installation

```
sudo /usr/bin/mysql_secure_installation
```

Ensure the MySQL Connector is installed

```
sudo yum install mysql-connector-java
```


Create databases for the Activity Monitor, Reports Manager, Hive Metastore, Sentry Server, Cloudera Navigator Audit Server, and Cloudera Navigator Metadata Server:

Login into MySQL as root user:

```
mysql -u root -p
```

eg mysql> 
create database database DEFAULT CHARACTER SET utf8;
grant all on database.* TO 'user'@'%' IDENTIFIED BY 'password';

mysql> create database amon DEFAULT CHARACTER SET utf8;
grant all on amon.* TO 'amon_user'@'%' IDENTIFIED BY 'amon_password';

mysql> create database rman DEFAULT CHARACTER SET utf8;
grant all on rman.* TO 'rman_user'@'%' IDENTIFIED BY 'rman_password';

mysql> create database metastore DEFAULT CHARACTER SET utf8;
grant all on metastore.* TO 'hive'@'%' IDENTIFIED BY 'hive_password';

mysql> create database sentry DEFAULT CHARACTER SET utf8;
grant all on sentry.* TO 'sentry'@'%' IDENTIFIED BY 'sentry_password';

mysql> create database nav DEFAULT CHARACTER SET utf8;
grant all on nav.* TO 'hive'@'%' IDENTIFIED BY 'nav_password';

mysql> create database navms DEFAULT CHARACTER SET utf8;
grant all on navms.* TO 'navms'@'%' IDENTIFIED BY 'navms_password';


Run scm prepare script

```
/usr/share/cmf/schema/scm_prepare_database.sh
```