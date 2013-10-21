#!/bin/bash -ex


date=$1
sum=0;
avg=0;
#=========cpu==================
for file in ./benchmark/$date/*/*/pgStatsInfo/pg_stats_info_report.txt
do
{
        val=0;
        val=`cat  $file | grep "WAL Write Total  :" | awk '{ print $5}'`
        sum=`echo "$sum + $val" | bc`
	path=`dirname $file`
	f=${path%/*}
	f=${f%/*}
}
done

        avg=`echo "$sum / 3.00" | bc -l `
        echo "========Wal Write:-============" > $f/wal_avg_all.txt 2> error.log
        echo "WAL Write Total  :$avg" >> $f/wal_avg_all.txt 2> error.log




sum=0;
avg=0;

for file in ./benchmark/$date/*/*/pgStatsInfo/pg_stats_info_report.txt
do
{
        val=0;
        val=`cat  $file | grep "WAL Write Speed  :" | awk '{ print $5}'`
        sum=`echo "$sum + $val" | bc`
        path=`dirname $file`
        f=${path%/*}
        f=${f%/*}
 #       echo $f
}
done

        avg=`echo "$sum / 3.00" | bc -l `
        echo "WAL Write Speed  :$avg" >> $f/wal_avg_all.txt 2> error.log

