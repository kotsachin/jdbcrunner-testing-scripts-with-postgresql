#!/bin/bash

date=$1

for file in ./benchmark/$date/*/*/gnuInput/*_t.dat
        do

                fwp=$(basename $file)
                img=${fwp%.*}

                path=`dirname $file`
                f=${path%/*}

		chk=`cat $f/pgStatsInfo/checkpoint_2.csv | head -n 1  | awk '{ print $3}'`
		echo $chk
		if [ ! -z $chk ]
                then
	
			st=`cat $f/jdbcRunnerLogs/jdbcrunner.log | grep "$chk" | awk '{ print $6}'`
			echo $st
	
			chk_type=`cat $f/pgStatsInfo/checkpoint_2.csv | head -n 1  | awk '{ print $5}'`
			echo $chk_type
			if [ "$chk_type" == "time" ]
			then
				nd=`cat $f/pgStatsInfo/checkpoint_2.csv | head -n 1  | awk '{ print $12}'`
				sync=`cat $f/pgStatsInfo/checkpoint_2.csv | head -n 1  | awk '{ print $11}'`
			else
				
				nd=`cat $f/pgStatsInfo/checkpoint_2.csv | head -n 1  | awk '{ print $13}'`
				sync=`cat $f/pgStatsInfo/checkpoint_2.csv | head -n 1  | awk '{ print $12}'`
			fi
                
			#sed 's/,/\t/g' $file | sed 1d > ./benchmark/$date/$server/$run/gnuInput/$img.dat
			nd=`echo "$st + $nd" | bc`
			sync=`echo "$nd - $sync" | bc`
                	echo $nd
			echo $sync

                	cat $file | awk \
 			-v ts=$st -v val=0 -v val1=0 -v end=$nd -v sy=$sync \
			'BEGIN{ORS="";} {if( ($1<ts) || ($1>end) ){ val=0; i=1; val1=0; while(i<=NF) {print $i," "; i=i+1; } print val,"   "val1"\n";} \
			else if($1>sy){ val=50; i=1; val1=50; while(i<=NF) {print $i," "; i=i+1; } print val,"   "val1"\n";} \
			else{ val=50; i=1; val1=0;  while(i<=NF) {print $i," "; i=i+1; } print val,"   "val1"\n";} }' \
			> $f/gnuInput/chk.dat


		fi
        done



