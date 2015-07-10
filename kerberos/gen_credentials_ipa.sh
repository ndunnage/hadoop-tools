#!/bin/bash

IPA_SERVER=ipaserver.ent.cloudera.com
REALM=EXAMPLE.COM
KEYTAB_FILE=/etc/cloudera-scm-server/cmf.keytab
CM_PRINC=cloudera-manager@$REALM

# Explicitly add RHEL5/6 and SLES11 locations to path
export PATH=/usr/kerberos/bin:/usr/kerberos/sbin:/usr/lib/mit/sbin:/usr/sbin:$PATH

LOGFILE=/tmp/cm-get-keytabs.log

echo "-----------------" >> $LOGFILE
echo `date` >> $LOGFILE
echo "-----------------" >> $LOGFILE

# first, get ticket for CM principal
kinit -kt $KEYTAB_FILE $CM_PRINC

#CM is going to use /tmp for DEST
DEST=$1
#echo "dest: $DEST" >> $LOGFILE

#CM is going to input the principal as <service>/<hostname>@REALM
PRINCIPAL=$2
echo "[INFO] getting principal: $PRINCIPAL" >> $LOGFILE

#Because CM uses the service/fqdn@REALM format we need to parse this string to determine the keytab name.
PRINC=${PRINCIPAL%%/*}

# get FQDN of host from principal
HOST=`echo $PRINCIPAL | cut -d "/" -f 2 | cut -d "@" -f 1`

ipa service-find $PRINCIPAL
if [[ $? -eq 0 ]]; then
  princ_exists=yes
else
  princ_exists=no
  ipa service-add $PRINCIPAL
fi

KEYTAB_PATH=/tmp/${PRINC}_${HOST}.keytab
if [[ $princ_exists = "yes" && ${PRINCIPAL:0:5} = "HTTP/" && $IPA_SERVER = $(hostname -f) ]] ; then
  # This service principal and the corresponding keytab is used by ipa, do not regenrate, use saved copy
  cp /etc/cloudera-scm-server/http.keytab $KEYTAB_PATH
else
  ipa-getkeytab --principal=$PRINCIPAL --keytab=$KEYTAB_PATH --server=$IPA_SERVER
fi



if [ ! -e $KEYTAB_PATH ] ; then
  echo "[ERROR]: keytab not downloaded for principal: $PRINCIPAL" >> $LOGFILE
  kdestroy
  exit 1
else
  CMD="cp $KEYTAB_PATH $DEST"
  eval $CMD
  rm -f $KEYTAB_PATH
fi

# success
kdestroy
exit 0
