#!/bin/bash
t="21:41:25.179263 IP 192.229.189.142.https > r-39-98-25-172.comp.nus.edu.sg.49812: Flags [.], seq 334030:335410, ack 39545, win 363, length 1380"
#y=`sed -e 's/.*comp.\(.*\).edu.*/\1/' s.txt`
#echo $y

if [[ $t =~ "https" ]] ;
	then 
	echo "pattern matched";
else
	echo "pattern not matched";
fi

file="s.txt"

if [ ! -f "$file" ] ; then 
	touch "$file"
fi

ip_1=`sed -e 's/.*IP \(.*\) >.*/\1/' "$file" > sam.txt`

timestamp=`grep -oP '.*? (?=IP)' $file`
echo $timestamp
