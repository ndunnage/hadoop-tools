#!/bin/sh
# Setup up in the data directories on hdfs
# Run the teragen to generate 10Gb of data
# Run the terasort benchmark test
# check the user is added in hue and the client configuration is deployed
set -x
 
sudo -u hdfs dfs -mkdir /user/azureuser
sudo -u hdfs dfs -chown azureuser:azureuser /user/azureuser
hdfs dfs -rm -r /user/azureuser/teragen-output
hdfs dfs -rm -r /user/azureuser/terasort-output
 
# 10GB =    100 000 000 lines
#100GB =  1 000 000 000 lines
#  1TB = 10 000 000 000 lines
hadoop jar /opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/hadoop-mapreduce-examples.jar teragen \
-D mapred.map.tasks=10 \
100000000 /user/azureuser/teragen-output
 
hadoop jar /opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/hadoop-mapreduce-examples.jar terasort \
-D mapred.reduce.tasks=5 \
-D io.sort.record.percent=0.13 \
-D io.sort.spill.percent=0.98 \
-D mapred.reduce.slowstart.completed.maps=0.4 \
/user/azureuser/teragen-output /user/azureuser/terasort-output