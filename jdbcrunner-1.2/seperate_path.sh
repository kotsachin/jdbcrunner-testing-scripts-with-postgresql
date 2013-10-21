#!/bin/bash

date=$1

for file in ./benchmark/$date/*/*/jdbcRunnerLogs/*.txt
        do
	fwp=$(basename $file) 
	img=${fwp%.*} 
               path=`dirname $file`
#		echo $path
                #mkdir -p ./benchmark/$date/$server/$run/gnuInput
               # sed 's/,/\t/g' $file | sed 1d > ./benchmark/$date/$server/$run/gnuInput/$img.dat
F=${path%/*}
echo ${F##*/}

echo $img
        done
#F="./benchmark/2013-03-31-12-33-02/Server1/Run1/jdbcRunnerLogs"
#dirname $F
#echo "\n"
#echo $F

#F=${F%/*}
#string="./benchmark/2013-04-01-15-07-33/Master/Run1/jdbcRunnerLogs"

#res=grep "Master" 

#print first
#print last


