#!/bin/bash

exec 3<> /tmp/foo

fno=$1
echo "Generating Packet ordering list for day "$fno"..."

fname="day_"$fno"_inout.txt"

for i in $(seq 0 34)
do
	fnameout="day_"$fno"_pol_URL_"$i".txt"
	fnamein="day_"$fno"_inpol_URL_"$i".txt"
	`truncate -s 0 "$fnameout"`
	`truncate -s 0 "$fnamein"`
	echo "File: "$i"..."

	#setting initial list as [0,0,0]
	total=0
	out=0
	in=0
	totaloutpkt=0
	totalinpkt=0
	lines=0

	while true
	do
		read -r sign <&3 || break

		length=$(echo $sign| cut -d' ' -f 2)

		if [[ $sign =~ "out" ]]
		then			
			echo $in"	"$out"	"$total >> $fnameout
			out=$(($out+$length))
			totaloutpkt=$(($totaloutpkt+1))
		else
			echo $in"	"$out"	"$total >> $fnamein
			in=$(($in+$length))
			totalinpkt=$(($totalinpkt+1))
		fi
		total=$(($total+$length))
		lines=$(($lines+1))
	done 3<"analysis_"$i".txt"
	
	echo $i"	"$in"	"$out"	"$total >> $fname
	echo "Total items in outgoing packet order list = "$totaloutpkt
	echo "Total items in incoming packet order list = "$totalinpkt
	echo "Total in pkts = "$in
	echo "Total out pkts = "$out
	echo "Total packets = "$total
	echo "Total lines read = "$lines
done
