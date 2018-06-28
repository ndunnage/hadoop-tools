#!/bin/sh
# Setup up in the data directories on hdfs
# Run the teragen to generate 10Gb of data
# Run the terasort benchmark test
# check the user is added in hue and the client configuration is deployed
set -x

DIRECTORY=/user/test
GENDIRECTORY=/user/test/teragen
SORTDIRECTORY=/user/test/terasort

hadoop fs -rm -r $GENDIRECTORY
hadoop fs -rm -r $SORTDIRECTORY

# 10GB =    100 000 000 lines
#100GB =  1 000 000 000 lines
#  1TB = 10 000 000 000 lines
hadoop jar /opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/hadoop-mapreduce-examples.jar teragen \
-D mapred.map.tasks=20 \
100000000 $GENDIRECTORY

hadoop jar /opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/hadoop-mapreduce-examples.jar terasort \
-D mapred.reduce.tasks=20 \
-D io.sort.record.percent=0.13 \
-D io.sort.spill.percent=0.98 \
-D mapred.reduce.slowstart.completed.maps=0.4 \
$GENDIRECTORY $SORTDIRECTORY