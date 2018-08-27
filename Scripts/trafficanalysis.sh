#!/bin/bash

exec 3<> /tmp/foo
exec 4<> /tmp/foo
exec 5<> /tmp/foo
exec 6<> /tmp/foo

`truncate -s 0 analysis.txt`

fileno=0

#listening to each url for 10s and then storing the signatures in captured_signatures.txt
while true
do
	filename="cappkt_"$fileno".pcap"
	read -r url <&6 || break
	domain=$(echo "$url"| awk -F/ '{print $3}')

	`sudo truncate -s 0 "$filename"`
	fname="analysis_"$fileno".txt"
	echo $fname
	`truncate -s 0 "$fname"`

	`firefox -new-window -url "$url" &`
	echo "Listening for "$domain
	`sudo tcpdump -G 5 -W 1 -w "$filename" port https and src or dst "$domain"`
	`sudo tcpdump -r "$filename" > captured_signatures.txt`
	`sed -e 's/.*IP \(.*\) >.*/\1/' captured_signatures.txt > temp.txt`
	`sed -e 's/IP.*//' captured_signatures.txt > timestamp.txt`
	`sed -e 's/^.*length //' captured_signatures.txt > length.txt`
	
	#closing the firefox tab
	`DISPLAY=:0.0 wmctrl -c "Firefox"`

	#drafting an analysis file with timestamp, length and direction (in/out) of the packets
	while true
	do
		read -r ip_adr <&3 || break
		read -r time <&4 || break
		read -r length <&5 || break
		if [[ $ip_adr =~ ".https" ]]
		then
			value=$time" "$length" in"
		else
			value=$time" "$length" out"
		fi	
		echo $value >> $fname
	done 3<"temp.txt" 4<"timestamp.txt" 5<"length.txt"

	`rm temp.txt`
	`rm timestamp.txt`
	`rm length.txt`
	`rm captured_signatures.txt`

	fileno=$(($fileno+1))

done 6<"test_urls.txt"
