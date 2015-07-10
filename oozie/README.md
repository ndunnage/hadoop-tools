## Usefull Oozie commands
Ooze reference page http://archive.cloudera.com/cdh5/cdh/5/oozie/DG_CommandLineTool.html#Checking_the_Status_of_the_Oozie_System

# List the installed Share libraries

```
sudo -u oozie oozie  admin -shareliblist -oozie http://localhost:11000/oozie
```

# Create the share libs using the yarn jar

```
sudo /opt/cloudera/parcels/CDH/bin/oozie-setup sharelib create -fs hdfs://hostname:8020 -locallib /opt/cloudera/parcels/CDH-5.4.1-1.cdh5.4.1.p0.6/lib/oozie/oozie-sharelib-yarn
```

# Update the sharelibs using the yarn jar

```
sudo /opt/cloudera/parcels/CDH/bin/oozie-setup sharelib upgrade -fs hdfs://hostname:8020 -locallib /opt/cloudera/parcels/CDH-5.4.1-1.cdh5.4.1.p0.6/lib/oozie/oozie-sharelib-yarn
```