## Benchmark Installation
The benchmark script is a good first test to ensure the cluster is operable.
1. Create the azureuser in Hue ensuring the Create Home direcotry option is selected
2. Ensure the client configuration is deployed for the hdfs servie using Cloudera Manager
3. Benchmark.sh will run the terasort benchmark from hadoop-mapreduce-examples.jar, it will use the /user/azureuser directory to store data

## DFSIO Test
This creates 10 input files of 1GB Note the paths represent a Cloudera 5 parcels installation

1. Write Test

```
hadoop jar /opt/cloudera/parcels/CDH/lib/hadoop-hdfs/hadoop-hdfs-2.3.0-cdh5.0.1-tests.jar TestDFSIO -write -nrFiles 10 -fileSize 1000
``` 

2. Read Test

```
hadoop jar /opt/cloudera/parcels/CDH/lib/hadoop-hdfs/hadoop-hdfs-2.3.0-cdh5.0.1-tests.jarTestDFSIO -read -nrFiles 10 -fileSize 1000
``` 

3. Clean everything up

```
hadoop jar /opt/cloudera/parcels/CDH/lib/hadoop-hdfs/hadoop-hdfs-2.3.0-cdh5.0.1-tests.jar TestDFSIO -clean
``` 