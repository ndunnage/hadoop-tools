## Benchmark Installation
The benchmark script is a good first test to ensure the cluster is operable.
1. Create the azureuser in Hue ensuring the Create Home direcotry option is selected
2. Ensure the client configuration is deployed for the hdfs servie using Cloudera Manager
3. Benchmark.sh will run the terasort benchmark from hadoop-mapreduce-examples.jar, it will use the /user/azureuser directory to store data