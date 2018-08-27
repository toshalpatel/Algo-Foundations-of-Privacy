#!/bin/bash

exec 3<> /tmp/foo

#number series file
file="signature.dat"
if [ ! -f "$file" ] ; then 
	touch "$file"
fi

`truncate -s 0 signature.dat`

fno=$1
echo "Generating signatures for "$fno" files"


for i in $(seq 0 $fno)
do
	fname="signature_"$i".txt"
	`truncate -s 0 "$fname"`
	echo "File: "$i

	#setting bucketsize as 0.01s
	bucketsize=10
	begintime=0
	out=0
	in=0
	packetcount=0
	while true
	do
		read -r sign <&3 || break

		#calculating time in ms
		timestamp=$(echo $sign| cut -d' ' -f 1)
		h=$(echo $timestamp| cut -d':' -f 1)
		h=$((10#$h))
		m=$(echo $timestamp| cut -d':' -f 2)
		m=$((10#$m))
		s=$(echo $timestamp| cut -d':' -f 3)
		ms=$(echo $s| cut -d'.' -f 2)
		ms=$((10#$ms))
		ms=$(($ms/1000))
		ms=$((10#$ms))
		s=$(echo $s| cut -d'.' -f 1)
		s=$((10#$s))
		time=$(($h*3600000+$m*60000+$s*1000+$ms))

		#setting initial time bucket size
		if [[ $packetcount == 0 ]]
		then  
			beginbucket=$time
			endbucket=$(($beginbucket+$bucketsize))
		fi
		#echo "Bucket: "$beginbucket" - "$endbucket

		length=$(echo $sign| cut -d' ' -f 2)

		#building number series according to the time bucket
		if [[ $time -ge $beginbucket && $time -lt $endbucket ]]
		then
			#calculating the in and out packages per time bucket
			if [[ $sign =~ "out" ]]
			then
				out=$(($out+$length))
			else
				in=$(($in+$length))
			fi
		else
			begintime=$(($begintime+$bucketsize))
			echo $begintime"	"$in"	"$out >> $fname
			echo $begintime"	"$in"	"$out >> signature.dat
			#echo $time"	"$in"	"$out
			if [[ $sign =~ "out" ]]
			then
				out=$length
				in=0
			else
				in=$length
				out=0
			fi
			while true
			do
				tin=0
				tout=0
				beginbucket=$endbucket
				endbucket=$(($beginbucket+$bucketsize))
				#echo "#Bucket: "$beginbucket" - "$endbucket
				if [[ $time -ge $beginbucket && $time -lt $endbucket ]]
				then
					break
				fi
				begintime=$(($begintime+$bucketsize))
				echo $begintime"	"$tin"	"$tout >> $fname
				echo $begintime"	"$tin"	"$tout >> signature.dat
				#echo $time"	"$tin"	"$tout
			done
		fi
		packetcount=$(($packetcount+1))

	done 3<"analysis_"$i".txt"

	echo "Number of packet scanned: "$packetcount

	fileout="SignaturePlot_URL"$i
	gnuplot -persist <<-EOFMarker
		set title "Traffic Analysis" font ",11" textcolor rgbcolor "royalblue"
		set xlabel "Timestamp (10 milliseconds)"
		set ylabel "Packet Size (bytes)"
		set xtics font ",11"
		set ytics font ",11"
		stats "signature.dat" using 1 name "x" nooutput
		set xrange [x_min/10:x_max/10]
		set key font ", 11"
		set grid
		set terminal png size 1000,500 enhanced font "Helvetica,20"
		set output "${fileout}.png"
		plot "signature.dat" u (column(0)):2 lt rgb "red" with lines title "Inbound Traffic", "signature.dat" u (column(0)):3 lt rgb "blue" with lines title "Outbound Traffic"
		set output
	EOFMarker

`truncate -s 0 signature.dat`
done
