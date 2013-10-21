#!/bin/bash


for file in Result/benchmark/*/*/run1/bkp_result*
do
{
	fwp=$(basename $file)
        img=${fwp%.*}

        path=`dirname $file`
        fo=${path%/*}
        f=${fo%/*}
	#echo $fwp

	star=`cat $file | sed -n 1p |  awk '{ print $6}' | cut -c 12-19 | sed  's/-/:/g'`
	#echo `date -d "1970-01-01 $star UTC $star seconds" +"%H:%M:%S"`
	#star=$((star + 6))
	#echo $star
	end=`cat $file | sed -n 2p |  awk '{ print $6}' | cut -c 12-19 | sed  's/-/:/g'`
	
	st=`cat $f/Master/run1/jdbcRunnerLogs/jdbcrunner.log | grep "$star" | awk '{ if($3 != "[WARN"){print $6} }'`
	nd=`cat $f/Master/run1/jdbcRunnerLogs/jdbcrunner.log | grep "$end" | awk '{ if($3 != "[WARN"){print $6} }'`
	cat $f/Master/run1/gnuInput/chk2.dat | awk \
			-v ts=$st -v val=0 -v val1=25 -v end=$nd \
                        'BEGIN{ORS="";} {if( ($1>=ts) && ($1<=end) ){ i=1; while(i<=NF) {print $i," "; i=i+1; } print val1,"\n";} else{ i=1; while(i<=NF) {print $i," "; i=i+1; } print val,"\n";} }' \
                        > $f/Master/run1/gnuInput/chk3.dat


}
done





for file in Result/benchmark/*/*/run2/bkp_result*
do
{
	fwp=$(basename $file)
        img=${fwp%.*}

        path=`dirname $file`
        fo=${path%/*}
        f=${fo%/*}
	#echo $fwp

	star=`cat $file | sed -n 1p |  awk '{ print $6}' | cut -c 12-19 | sed  's/-/:/g'`
	#echo `date -d "1970-01-01 $star UTC $star seconds" +"%H:%M:%S"`
	#star=$((star + 6))
	#echo $star
	end=`cat $file | sed -n 2p |  awk '{ print $6}' | cut -c 12-19 | sed  's/-/:/g'`
	
	st=`cat $f/Master/run2/jdbcRunnerLogs/jdbcrunner.log | grep "$star" | awk '{ if($3 != "[WARN"){print $6} }'`
	nd=`cat $f/Master/run2/jdbcRunnerLogs/jdbcrunner.log | grep "$end" | awk '{ if($3 != "[WARN"){print $6} }'`
	cat $f/Master/run2/gnuInput/chk2.dat | awk \
			-v ts=$st -v val=0 -v val1=25 -v end=$nd \
                        'BEGIN{ORS="";} {if( ($1>=ts) && ($1<=end) ){ i=1; while(i<=NF) {print $i," "; i=i+1; } print val1,"\n";} else{ i=1; while(i<=NF) {print $i," "; i=i+1; } print val,"\n";} }' \
                        > $f/Master/run2/gnuInput/chk3.dat


}
done





for file in Result/benchmark/*/*/run3/bkp_result*
do
{
	fwp=$(basename $file)
        img=${fwp%.*}

        path=`dirname $file`
        fo=${path%/*}
        f=${fo%/*}
	#echo $fwp

	star=`cat $file | sed -n 1p |  awk '{ print $6}' | cut -c 12-19 | sed  's/-/:/g'`
	#echo `date -d "1970-01-01 $star UTC $star seconds" +"%H:%M:%S"`
	#star=$((star + 6))
	#echo $star
	end=`cat $file | sed -n 2p |  awk '{ print $6}' | cut -c 12-19 | sed  's/-/:/g'`
	
	st=`cat $f/Master/run3/jdbcRunnerLogs/jdbcrunner.log | grep "$star" | awk '{ if($3 != "[WARN"){print $6} }'`
	nd=`cat $f/Master/run3/jdbcRunnerLogs/jdbcrunner.log | grep "$end" | awk '{ if($3 != "[WARN"){print $6} }'`

	#echo $st
	#echo $nd
	#echo " "

	cat $f/Master/run3/gnuInput/chk2.dat | awk \
			-v ts=$st -v val=0 -v val1=25 -v end=$nd \
                        'BEGIN{ORS="";} {if( ($1>=ts) && ($1<=end) ){ i=1; while(i<=NF) {print $i," "; i=i+1; } print val1,"\n";} else{ i=1; while(i<=NF) {print $i," "; i=i+1; } print val,"\n";} }' \
                        > $f/Master/run3/gnuInput/chk3.dat

}
done




