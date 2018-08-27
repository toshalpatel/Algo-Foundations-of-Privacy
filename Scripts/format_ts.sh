#!/bin/bash

exec 3<> /tmp/foo

fno=$1
echo "Formatting the files according to the timestamps..."


for i in $(seq 0 $fno)
do
	#setting the filename
	fname="traffic_analysis_"$i".txt"
	`truncate -s 0 "$fname"`
	echo "Updating file: "$i

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
		length=$(echo $sign| cut -d' ' -f 2)
		dir=$(echo $sign|cut -d' ' -f 3)

		start="00:00:00.000000"

		h=$(echo $timestamp| cut -d':' -f 1)
		h=$((10#$h))
		m=$(echo $timestamp| cut -d':' -f 2)
		m=$((10#$m))
		s=$(echo $timestamp| cut -d':' -f 3)
		ms=$(echo $s| cut -d'.' -f 2)
		ms=$((10#$ms))
		#ms=$(($ms/1000))
		#ms=$((10#$ms))
		s=$(echo $s| cut -d'.' -f 1)
		s=$((10#$s))
		#time=$(($h*3600000+$m*60000+$s*1000+$ms))

		#nmbeginning
		if [[ $packetcount == 0 ]]
		then
			hi=$h
			mi=$m
			si=$s
			msi=$ms
			echo $start" "$length" "$dir >> $fname
			#echo $start" "$length" "$dir
		else
			#time difference
			
			if [ $h -eq $hi ]
			then
				h=0
				if [ $m -eq $mi ]
				then
					m=0
					if [ $s -eq $si ]
					then
						s=0
						ms=$(($ms-$msi))
						ms=$(echo $ms | awk '{printf "%06d\n", $0;}')
					else
						tms=$((($s*1000000+$ms)-($si*1000000+$msi)))
						s=$(($tms / 1000000))
						s=$(echo $s | awk '{printf "%02d\n", $0;}')
						ms=$(($tms % 1000000))
						ms=$(echo $ms | awk '{printf "%06d\n", $0;}')
					fi
				else
					s=$(($m*60 + $s))
					tsi=$(($mi*60 + $si))
					ts=$((($s*1000000+$ms) - ($tsi*1000000+$msi)))
					s=$(($ts / 1000000))
					m=$(($s / 60))
					m=$(echo $m | awk '{printf "%02d\n", $0;}')
					s=$(($s % 60))
					s=$(echo $s | awk '{printf "%02d\n", $0;}')
					ms=$(($ts % 1000000))
					ms=$(echo $ms | awk '{printf "%06d\n", $0;}')
				fi
			fi
			T=$h":"$m":"$s"."$ms
			T=$(date -d "$T" '+%H:%M:%S.%6N')
			#echo $T" "$length" "$dir
			echo $T" "$length" "$dir >> $fname
		fi

		packetcount=$(($packetcount+1))
	done 3<"analysis_"$i".txt"
	echo "Number of packet scanned: "$packetcount
done
