#!/bin/bash
exec 3<> /tmp/foo
exec 4<> /tmp/foo

j=0
while true
do
	read -r i <&3 || break
	filename="packet_trace_"$i".txt"
	while true
	do
		read -r trace <&4 || break
		echo $trace >> $filename
	done 4<"traffic_analysis_"$j".txt"
	j=$(($j+1))
done 3<"keys.txt"
