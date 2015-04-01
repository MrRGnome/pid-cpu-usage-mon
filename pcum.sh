#!/bin/bash
#
#   Tested only on Red Hat Enterprise
#


pollInterval=$2
sleep 1
while true;
do
	IFS=$'\n' read -rd '' -a processArray <<< "$(UNIX95= ps -e -o pid,command | grep $1 | grep -v 'grep\|pid-cpu-usage-mon')"
	declare tick_definition="$(getconf CLK_TCK)"
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
				outputStr="$outputStr$usage $pid\n"
			fi
			oldCpuTime[$pid]=$newTime
		done < "/proc/$pid/stat"
	done
	if [ ! -z "$outputStr" ]
	then
		echo -e $outputStr
	fi
	sleep $pollInterval
done
