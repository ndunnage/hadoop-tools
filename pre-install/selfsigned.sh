#!/bin/bash
# Create a new new keystore and generate a self signed certificate for each node
DIRECTORY=/opt/cloudera/security
for i in $(cat test.txt)
do
ssh -t $i "bash -c 'if [ ! -d ${DIRECTORY} ]; then
mkdir ${DIRECTORY} && \
keytool -genkeypair -keystore ${DIRECTORY}/${i}.keystore -keyalg RSA -alias test -dname CN=${i}.dc-ratingen.de,O=Vodafone -storepass changeme -keypass changeme -validity 90 && \
echo \"generated ${i} self signed certificate and keystore\"
fi' "
done
