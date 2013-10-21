#!/bin/bash
date='2013-02-14-17-16-18'
for file in ./benchmark/$date/dstatOutput/*.log
do
        #echo $file
        ts=`cat $file | grep " 1 sec" | awk '{print $1}'`
        echo $ts

        for tfile in ./benchmark/$date/dstatOutput/*.csv
                do

			echo $tfile
                        img=$(echo "$tfile" | cut -c 45-63)
                        cat $tfile | sed 2d |awk 'BEGIN{ORS="";}{i=2; while(i<=NF) {print substr($i,1,8),"\t";i++;} print "\n";} ' | awk -v str=$ts '{if($1>=str) print $0}' | awk -v val=1 'BEGIN{ORS="";} {if(val<=90) {i=2; print val,"\t"; while(i<=NF) {print $i,"\t"; i=i+1; } print "\n";} val=val+1}' > ./benchmark/$date/dstatOutput/$img.csv
#awk 'BEGIN{ORS="";}{i=2; while(i<=NF) { if print $i,"\t";i++;} print "\n";} '
                        #cat $tfile | sed 1d | awk -v val=23 '{print val,$2; val=val+1}'
                done

done
