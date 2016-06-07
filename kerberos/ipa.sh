#! /bin/bash
IPA_SERVER=ipa-test.hadoop.dev
IPA_REALM=HADOOP.DEV
SCM_USER=scm

LOGFILE=/tmp/cm-get-keytabs.log

echo "-----------------" >> $LOGFILE
echo `date` >> $LOGFILE
echo "-----------------" >> $LOGFILE

#CM is going to use /tmp for DEST
DEST=$1
echo "dest: $DEST" >> $LOGFILE

# first, get ticket for cloudera-scm user
kinit -kt /var/lib/cloudera-scm-server/cmf.keytab ${SCM_USER}@${IPA_REALM}

#CM is going to input the principal as <service>/<hostname>@REALM
PRINCIPAL=$2
echo "[INFO] getting principal: $PRINCIPAL" >> $LOGFILE
#Because CM uses the service/fqdn@REALM format we need to parse this string to determine the ketab name
PRINC=${PRINCIPAL%%/*}
#PRINCHOST=${PRINCIPAL%%.*}

# get FQDN of host from principal
HOST=`echo $PRINCIPAL | cut -d "/" -f 2 | cut -d "@" -f 1`

#create principal if not existing
ipa service-find $2
if [[ $? -eq 0 ]]; then
princ_exists=yes
else
princ_exists=no
ipa service-add $2
fi

echo "[INFO] principal existed:$princ_exists" >> $LOGFILE

KEYTAB_PATH=/tmp/${PRINC}_${HOST}.keytab
echo "[INFO] ipa-getkeytab --principal=$2 --keytab=$KEYTAB_PATH --server=$IPA_SERVER" >> $LOGFILE
ipa-getkeytab --principal=$2 --keytab=$KEYTAB_PATH --server=$IPA_SERVER

if [ ! -e $KEYTAB_PATH ] ; then
echo "[ERROR]: keytab not downloaded for principal: $2" >> $LOGFILE
exit 1
else
CMD="cp $KEYTAB_PATH $DEST"
echo $CMD >> $LOGFILE
OUTPUT="$($CMD 2>&1)"
echo $OUTPUT >> $LOGFILE
fi

exit 0