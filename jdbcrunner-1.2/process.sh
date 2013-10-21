#!/bin/bash
date='2013-02-14-12-38-56'
for file in ./benchmark/$date/dstatOutput/*.log
do
        #echo $file
        ts=`cat $file | grep " 1 sec" | awk '{print $1}'`
        echo $ts

        for tfile in ./benchmark/$date/gnuInput/*_t.dat
                do

			echo $tfile
                        img=$(echo "$tfile" | cut -c 42-58)
                        cat $tfile | sed 1d | awk -v val=$(date -d $val' 1 sec' +%T)'{print val,$2;}'
                        #cat $tfile | sed 1d | awk -v val=23 '{print val,$2; val=val+1}'
                done

done
