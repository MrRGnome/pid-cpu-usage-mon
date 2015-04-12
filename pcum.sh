#!/bin/bash
#
#   Requires getconf and bc
#

if [ -z $1 ] || [ -z $2 ];
then
	printf "Please include 2 arguments, a search string and a monitoring interval in seconds"
	printf "Example: bash pcum.sh MyApp.py 5"
	exit
fi

declare tick_definition="$(getconf _SC_CLK_TCK)"
if [[ -z $tick_definition ]];
then
	tick_definition="$(getconf CLK_TCK)"
fi

pollInterval=$2
sleep 1
while true;
do
	IFS=$'\n' read -rd '' -a processArray <<< "$(UNIX95= ps -e -o pid,command | grep $1 | grep -v 'grep\|pcum')"
	index=0
	lastIndex=$((${#processArray[@]} - 1))
	for processLine in "${processArray[@]}";
	do
		IFS=' ' read -a processArrLine <<< ${processLine[@]}
		pid=${processArrLine[0]}
		while read line;
		do
			IFS=' ' read -a array <<< "$line"
			newTime=$(( ${array[13]]} + ${array[14]]} + ${array[15]]} + ${array[16]]}))
			if [ ! -z "${oldCpuTime[$pid]}" ]
			then
				mathStr="((($newTime-${oldCpuTime[$pid]})/$pollInterval)/$tick_definition)*100"
				usage=`echo $mathStr|bc`
				outputStr="$outputStr$usage $pid"
				if [ $index -lt $lastIndex ]
				then
					index=$(($index+1))
					outputStr="$outputStr\n"
				fi
			fi
			oldCpuTime[$pid]=$newTime
		done < "/proc/$pid/stat"
	done
	if [ ! -z "$outputStr" ]
	then
		outputStr=${outputStr//$'\n'/}
		echo -e $outputStr
		outputStr=""
	fi
	sleep $pollInterval
done
