#!/bin/bash

t="17:03:12.007656 1368 out"
bucketsize=1000
beginbucket=$(echo $t| cut -d' ' -f 1)
echo $beginbucket
begintime=$(echo $beginbucket| cut -d':' -f 3)
echo $begintime
endtime=$(echo "$begintime + $bucketsize" | bc)
echo $endtime
endbucket=$(echo "${beginbucket/begintime/$endtime}")
echo $endbucket

echo "time"
hour=${hour#0}
h=$(echo $beginbucket| cut -d':' -f 1)
m=$(echo $beginbucket| cut -d':' -f 2)
s=$(echo $beginbucket| cut -d':' -f 3)
ms=$(echo $s| cut -d'.' -f 2)
ms=$((10#$ms))
ms=$(($ms/1000))
s=$(echo $s| cut -d'.' -f 1)
timeinms=$(($h*3600000000+$m*60000000+$s*1000000+$ms))
echo "ms-- "$ms

beginbucket=$timeinms
endbucket=$(($beginbucket+$bucketsize))

if [[ $beginbucket < $endbucket ]]
then
	echo "less than, equal to"
else
	echo "greater than"
fi

length=$(echo $t| cut -d' ' -f 2)
if [[ $t =~ "out" ]]
then
	length=$(($length*-1))
fi
echo $length

f="sam.txt"
`truncate -s 0 "$f"`
