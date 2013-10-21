#!/bin/bash

#for file in ./Result/benchmark/*/*/*/RESULT*
for file in ./Result/benchmark/*/*/*/BKP*
#for file in ./Result/benchmark/*/RUN*
do
{
		path=`dirname $file`
                f=${path%/*}
		#echo $path
		#cp -f $file $path/result.txt
		#cp -f $file $path/run_conf.txt
		cp -f $file $path/bkp_result.txt


}
done
