#!/bin/bash
# Run as hive user eg sudo -u hive
# Sqoop import from <databasename>
# The hive table gets automatically created in the Hive database
# Ensure the database jdbc driver is installed for parcels this is
# /opt/cloudera/parcels/CDH-4.6.0-1.cdh4.6.0.p0.26/lib/sqoop/lib/

DB_CON="jdbc:sqlserver://azuredb.database.windows.net:1433;database=databasename"
# The driver value must be set for importing into Hive
DRIVER=com.microsoft.sqlserver.jdbc.SQLServerDriver
# Ensure characters are properly escaped for passwords eg '$passowrd%'
DB_USER=<Username>
DB_PASSWORD=<password>
SCHEMA_NAME=<schema_name>
DB_TABLE=<tablename>
HIVE_WAREHOUSE_DIR="/user/hive/warehouse/"
HIVE_DATABASE=<hivedatabasename>

##### sqoop Query #####
sqoop import \
--username ${DB_USER} \
--password ${DB_PASSWORD} \
--driver ${DRIVER} \
--verbose \
--connect ${DB_CON} \
--table ${SCHEMA_NAME}.${DB_TABLE} \
--warehouse-dir ${HIVE_WAREHOUSE_DIR} \
--hive-database ${HIVE_DATABASE} \
--hive-table    ${DB_TABLE} \
--hive-import \
-m 1
