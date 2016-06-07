x509='/opt/cloudera/security/x509'
CAcerts='/opt/cloudera/security/CAcerts'
JKSDIR="/opt/cloudera/security/jks/"
NEWPASSWORD="xxxxxxxxx"
StorePass="${NEWPASSWORD}"
StorePass="password"

JAVAH='/usr/java/jdk1.7.0_79'
keytool="${JAVAH}/bin/keytool"

#cm="vgddp030hr.dc-ratingen.de"
cm="vgddp030hr"
domain=".dc-ratingen.de"
prefix="vgddp"
suffix="hr"

start='001'
stop='016'

# Usage info
usage() {
cat << EOF
Usage: ${0##*/} [-key keyarg]

Parameters are:

    -m name         manager node short name, current - ${cm}
    -h              display this help
    -f start        start node, current - ${start}
    -l last         last node, current - ${stop}
    -p prefix       prefix, current ${prefix}
    -s suffix       suffix, current ${suffix}
    -d domain       domain, current ${domain}
    -e              exit when this key found

EOF
}


while getopts ":hm:f:l:p:s:d:e" opt; do
    case $opt in
       h)
            usage
            #exit 0
            ;;

       m)
            if [[ $OPTARG = -* ]]; then
                ((OPTIND--))
                continue
            fi
            cm=$OPTARG
            ;;

       f)
            if [[ $OPTARG = -* ]]; then
                ((OPTIND--))
                continue
            fi
            start=$OPTARG
            ;;

       l)
            if [[ $OPTARG = -* ]]; then
                ((OPTIND--))
                continue
            fi
            stop=$OPTARG
            ;;

       p)
            if [[ $OPTARG = -* ]]; then
                ((OPTIND--))
                continue
            fi
            prefix=$OPTARG
            ;;

       s)
            if [[ $OPTARG = -* ]]; then
                ((OPTIND--))
                continue
            fi
            suffix=$OPTARG
            ;;

       d)
            if [[ $OPTARG = -* ]]; then
                ((OPTIND--))
                continue
            fi
            domain=$OPTARG
            ;;

       e)
            if [[ $OPTARG = -* ]]; then
                ((OPTIND--))
                continue
            fi
            exit
            ;;

        \?)
            echo "Invalid option: -$OPTARG" >&2
            usage
            exit 1
            ;;

        :)
            echo "Option -$OPTARG requires an argument." >&2
            usage
            exit 1
            ;;
    esac
done


#-h -m MMMMMM -f FFFFFF -l LLLLLL -p PPPPPP -s SSSSSS -d DDDDDD -h -e

script_dir=${BASH_SOURCE%/*}
if [ ! -r ${script_dir}/Certs-Prepare-On-Remote-Cnode.sh  ]
then
    echo "Missing required parts of script bundle, or wrong permissions. Exiting"
    exit 1
fi

#for hostid in {001..016}
for hostid in $(eval echo "{$start..$stop}")
do
    shorthost="${prefix}${hostid}${suffix}"
    sshhostname="${shorthost}{domain}"

    echo ${sshhostname}
    #if [ ${hostid} -ne 030 ]; then
    if [ ${cm} != ${shorthost} ]; then
	#install openssl perl to perform all required setup
	#ssh ${sshhostname} "yum install -y openssl-perl"

	#setup directories
	ssh ${sshhostname} "mkdir -p ${x509}; mkdir -p ${CAcerts}"

	#copy CAcerts and CM cert to all nodes
	#scp ${x509}/${cm}_cert.pem root@${sshhostname}:${x509}/${cm}_cert.pem
	scp ${x509}/${cm}.pem root@${sshhostname}:${x509}/
	scp ${CAcerts}/verizon.pem root@${sshhostname}:${CAcerts}/
	scp ${CAcerts}/baltimore.pem root@${sshhostname}:${CAcerts}/


	#copy cert and chain7cert to respective node
	#scp ${x509}/${sshhostname}_cert.pem root@${sshhostname}:${x509}/${sshhostname}_cert.pem
	#scp ${x509}/${sshhostname}_chainp7.pem root@${sshhostname}:${x509}/${sshhostname}_chainp7.pem
	scp ${x509}/${shorthost}.pem root@${sshhostname}:${x509}/
	scp ${x509}/${shorthost}_chainp7.pem root@${sshhostname}:${x509}/

	#for the management node add current host to cm.truststore
	keytool -importcert -keystore ${JKSDIR}cm.truststore -alias ${shorthost} -storepass changeit -file ${x509}/${shorthost}.pem

	# prepare remote java keystores and host private key
	ssh root@${sshhostname} x509=${x509} CAcerts=${CAcerts} JKSDIR=${JKSDIR} NEWPASSWORD=${NEWPASSWORD} StorePass=${StorePass} JAVAH=${JAVAH} keytool=${keytool} cm=${cm} domain=${domain} 'bash ' < ${script_dir}/Certs-Prepare-On-Remote-Cnode.sh

    else
	#for the management node
	keytool -importcert -keystore ${JKSDIR}cm.truststore -alias rootca -storepass changeit -file ${CAcerts}/verizon.pem
	# prepare java keystores
	node_cmds
    fi
done


function node_cmds
{
local shorthost

# Lines below are required to be stored in Certs-Prepare-On-Remote-Cnode.sh in the same directory as this script.
# This script will be executed on remote node vis ssh.
# This function executed for manager node

shorthost=$(hostname -s)
${keytool} -importcert -trustcacerts -alias SubordinateCA  -keystore ${JKSDIR}${shorthost}-keystore.jks -file ${CAcerts}/verizon.pem   - storepass ${StorePass}
${keytool} -importcert -trustcacerts -alias SubordinateCA2 -keystore ${JKSDIR}${shorthost}-keystore.jks -file ${CAcerts}/baltimore.pem  -storepass ${StorePass}
${keytool} -importcert -trustcacerts -alias ${shorthost}   -keystore ${JKSDIR}${shorthost}-keystore.jks -file ${x509}/${shorthost}.pem  -storepass ${StorePass}

#export private key for node
${keytool} -v -srckeystore ${JKSDIR}${shorthost}-keystore.jks -srcstorepass ${StorePass} -srckeypass ${StorePass} -destkeystore \
    /tmp/${shorthost}-keystore.p12 -deststoretype PKCS12 -srcalias ${shorthost} -deststorepass ${StorePass} -destkeypass ${StorePass} 

openssl pkcs12 -in /tmp/${shorthost}-keystore.p12 -passin pass:${StorePass} -nocerts -out ${x509}/{shorthost}.key -passout pass:${StorePass}
rm /tmp/${shorthost}-keystore.p12

}
