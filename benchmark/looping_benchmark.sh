#!/bin/sh
# Looping terasort script
CDH_PATH=/opt/cloudera/parcels/CDH/lib/hadoop-0.20-mapreduce
for i in 2 4 8 16 32 64 # Number of mapper containers to test
do
	for j in 2 4 8 16 32 64 # Number of reducer containers to test      
	do                 
		for k in 1024 2048 # Container memory for mappers/reducers to test             
		do                         
			MAP_MB=`echo "($k*0.8)/1" | bc` # JVM heap size for mappers                    
			RED_MB=`echo "($k*0.8)/1" | bc` # JVM heap size for reducers                       
			hadoop jar $CDH_PATH/hadoop-examples.jar teragen -Dmapreduce.job.maps=$i -Dmapreduce.map.memory.mb=$k -Dmapreduce.map.java.opts.max.heap=$MAP_MB 100000000 /results/tg-10GB-${i}-${j}-${k} 1>tera_${i}_${j}_${k}.out 2>tera_${i}_${j}_${k}.err                       
			hadoop jar $CDH_PATH/hadoop-examples.jar terasort -Dmapreduce.job.maps=$i -Dmapreduce.job.reduces=$j -Dmapreduce.map.memory.mb=$k -Dmapreduce.map.java.opts.max.heap=$MAP_MB -Dmapreduce.reduce.memory.mb=$k -Dmapreduce.reduce.java.opts.max.heap=$RED_MB /results/ts-10GB-${i}-${j}-${k} 1>>tera_${i}_${j}_${k}.out 2>>tera_${i}_${j}_${k}.err                         
			hadoop fs -rmr -skipTrash /results/tg-10GB-${i}-${j}-${k}                         
hadoop fs -rmr -skipTrash /results/ts-10GB-${i}-${j}-${k}                 
		done
	done
done
