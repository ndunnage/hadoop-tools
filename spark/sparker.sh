#!/bin/sh
# sparker.sh
# An example spark-submit script
# first read in the variables set by Cloudera Manager

. /etc/spark/conf/spark-env.sh

/opt/cloudera/parcels/CDH-5.1.3-1.cdh5.1.3.p0.12/bin/spark-submit \
--class com.mycloudera.twitterprocessor.TwitterProcessor \
--deploy-mode client \
--master spark//$SPARK_MASTER_IP:$SPARK_MASTER_PORT \
/path/to/TwitterProcessor-assembly-0.1-SNAPSHOT.jar 10