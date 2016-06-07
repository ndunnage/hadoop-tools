#!/bin/bash
if [ -z "$1" ]; then
	echo "Specify the duration of the test"
	exit 1
fi
TEST_DURATION=$1

IPERF_OPTS="-t $TEST_DURATION -f m"
echo "Source Host, Dest Host,Throughput"
for fromhost in {017..025}
do
	fromhostname=$(echo vgddp$fromhost"hr")

	ssh $fromhostname "killall iperf" 2>/dev/null
	ssh $fromhostname 'rm -f /tmp/iperf_*' 2>/dev/null
	ssh $fromhostname "screen -d -m iperf -s & " 2>/dev/null
done

for fromhost in {017..025}
do	
	fromhostname=$(echo vgddp$fromhost"hr")
	for tohost in {017..025}
	do
		tohostname=$(echo vgddp$tohost"hr")

		if [ $fromhost -ne $tohost ]; then
			#echo -n $fromhostname".dc-ratingen.de",
			#FRAME_ERRORS=$(ssh $fromhostname "ifconfig eth4 | tr '\n' ' ' | grep -oh \"frame:[0-9]*\" | grep -o [0-9]*" 2>/dev/null) 
			#ssh $tohostname "screen -d -m iperf -c $fromhostname -f g $IPERF_OPTS | tr '\n' ' ' | grep -oh '[0-9\.]* [KMG]bits\/sec' | grep -oh '[0-9\.]*' | tr '\n' ',' > /tmp/iperf_$fromhostname_$tohostname & " 2>/dev/null
			ssh $tohostname "nohup iperf -c $fromhostname $IPERF_OPTS > /tmp/iperf_$fromhostname &" 2>/dev/null
			#FRAME_ERRORS_NEW=$(ssh $fromhostname "ifconfig eth4 | tr '\n' ' ' | grep -oh \"frame:[0-9]*\" | grep -o [0-9]*" 2>/dev/null)
			#echo $((FRAME_ERRORS_NEW-FRAME_ERRORS))
		fi
	done
done
sleep $(($TEST_DURATION+5))
for fromhost in {017..025}
do
	fromhostname=$(echo vgddp$fromhost"hr")
	ssh  $fromhostname "killall iperf" 2>/dev/null
	ssh $fromhostname 'for f in /tmp/iperf_*; do echo -n $(hostname -s)","; echo -n $f | grep -oh vgddp0[0-9][0-9]hr | tr -d "\n"; echo -n ","; cat $f | grep -oh '\''[0-9\.]* [KMG]bits\/sec'\'' | grep -oh '\''[0-9\.]*'\''; done' 2>/dev/null
done