## Flume Installation and configuration
Setup the Flume service via Cloudera Manager, included is a sample flume configuration file flume-solr.conf and morphline configuration solr-syslog morphline.conf

### Creating a syslog source with a solr sink
The flume agent will create a Syslog source on the local interface on port 7077, events can be redirected by the syslog service as folows:

```
sudo vim /etc/rsyslog.conf
``` 

Then add the following line to the bottom of the syslog service configuration file

```
*.*  @@127.0.0.1:7077
``` 

Flume agent will direct all events to the solr indexing sink, the morphlines will extract the fields which in turn will be indexed by Solr. Before testing you will need to create the solr collection.

From one of the Solr nodes execute the following command in order to create the skeleton Solr configuration files


```
solrctl instancedir --generate $HOME/your_solr_configs
``` 

Then make the collection available to Solr

```
solrctl instancedir --create syslogs $HOME/your_solr_configs
``` 

You can make changes to the schema.xml files. The example in the directory includes the additional syslog fields


Vertify the instance is available to zookeeper

```
solrctl instancedir --list
``` 

If everything is OK you can then create the collection. Note the -s this creates a single shard. The -r option sets the number of replicas. 

```
solrctl collection --create syslogs -s 1
``` 

The next stage is to configure the morphlines that will extract the fields. If you are using Cloudera Manager, you can edit the morphline file directly, via the Flume agent configuration. The solr-syslog-morphline.conf file will work with the schema.xml and  extract the priority, timestamp, hostname, program and message from the event and index these fields. You should now be able to start the flume agent which will collect the redirected syslog messages.

To test use the following command

```
logger -t sshd 'Testing Flume Ingestion with Syslog!'
``` 

### Create a 2 tier Apache Weblog pipeline
This configuration will feature a two tier flume architecture. Tier 1 will tail a directory for Apache logs and distribute to a 2 tier using an Avro sink. The tier2 Avro source will then write to hdfs using an avro sink. The tier2 agent configration flume-tier2.conf contains two channels, an hdfs sink and a local file system sink.

To create an Avro sink for the tier1 agent you can replace the sink with the following sink configuration, replacing the IP address and port accordingly for the tier2 agent node.

tier1.channels = channel1
tier1.sinks = sink1
tier1.sinks.sink1.type = avro
tier1.sinks.sink1.channel = channel1
tier1.sinks.sink1.hostname = 10.10.10.10
tier1.sinks.sink1.port = 4545

The sample flume configuration file flume-tier1-avro.conf can be started manually using the follwing command

```
flume-ng agent -c conf -f /etc/flume-ng/conf/flume-tier1-avro.conf -n tier1
``` 
The flume-tier1-avro.conf changes the syslog source to spooling directory source as follows:

tier1.sources.source1.spoolDir = /var/log/apache/

Once each log is read is renamed logname.COMPLETED

The apache_loggen.py will generate some sample weblogs, you can run this script to generate some sample weblogs in /var/log/apache

