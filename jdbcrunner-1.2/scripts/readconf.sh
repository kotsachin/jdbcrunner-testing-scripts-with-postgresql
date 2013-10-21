#!/bin/bash
# SCRIPT:  method1.sh
# PURPOSE: Process a file line by line with PIPED while-read loop.

FILENAME=$1
count=0
#cat $FILENAME | while read LINE
#do
#       let count++
#       echo "$count $LINE"
#done
#awk '{count++; if(count!=1) cnt=$1 wt=$2 mt=$3 na=$4
#system("java JR tpcc.js -warmupTime wt -measurementTime mt -nAgents na") }' $FILENAME
#awk '{system("java JR tpcc.js -warmupTime $2 -measurementTime$3 -nAgents$4") }' $FILENAME



#awk '{kount++;if(kount!=1) print $2 }' $FILENAME
#awk '{kount++;if(kount!=1) print $2; system("java JR tpcc.js -warmupTime $2") }' $FILENAME

#awk '{kount++;if(kount!=1) print $2; system("sh load_run.sh $1 $2 $3 $4") }' $FILENAME
while read nr wt mt na
do
        [ "$nr" == "NR" ] && continue                       # Skip the Header
        for i in [1..$nr]
	do
	java JR tpcc.js -warmupTime $wt -measurementTime $mt -nAgents $na       # Print values read in variable
	done
done < benchmark.conf

