#!/bin/sh
# Modifued benchmark

time hadoop jar /opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/hadoop-mapreduce-examples.jar teragen -Ddfs.block.size=1073741824
-Dmapred.map.tasks=1000 10000000000 $1  2>&1 | tee $1.out
time hadoop jar /opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/hadoop-mapreduce-examples.jar terasort -Dio.sort.record.percent=0.1379 -Dio.sort.factor -Ddfs.block.size=1073741824
-Dmapred.tasktracker.map.task.maximum=320
-Dmapred.jobtracker.maxtasks.per.job=-1
-Dmapred.tasktracker.reduce.task.maximum=32
-Dmapred.reduce.tasks=320 $1 $2 2>&1 | tee $2.out