#!/bin/bash


date=$1
sum=0;
avg=0;
rm -f ./Result/benchmark/$date/Master/dstat_avg_all.txt
#=========cpu==================
for file in ./Result/benchmark/$date/Master/*/dstat_avg_result.txt
do
{	
	val=0;
	val=`cat  $file | grep "usr:" | awk '{ print $2}'`
	sum=`echo "$sum + $val" | bc`
}
done

	avg=`echo "$sum / 3.00" | bc -l ` 
	echo "========CPU usage:-============" > ./Result/benchmark/$date/Master/dstat_avg_all.txt
	echo "user:$avg" >> ./Result/benchmark/$date/Master/dstat_avg_all.txt
	
	
sum=0;
avg=0;


for file in ./Result/benchmark/$date/Master/*/dstat_avg_result.txt
do
{
        val=0;
        val=`cat  $file | grep "sys:" | awk '{ print $2}'`
        sum=`echo "$sum + $val" | bc`
}
done

        avg=`echo "$sum / 3.00" | bc -l `
        echo "sys:$avg" >> ./Result/benchmark/$date/Master/dstat_avg_all.txt
	

sum=0;
avg=0;
for file in ./Result/benchmark/$date/Master/*/dstat_avg_result.txt
do
{
        val=0;
        val=`cat  $file | grep "wait:" | awk '{ print $2}'`
        sum=`echo "$sum + $val" | bc`
}
done

        avg=`echo "$sum / 3.00" | bc -l `
        echo "wait:$avg" >> ./Result/benchmark/$date/Master/dstat_avg_all.txt

#===========================network=========

sum=0;
avg=0;
for file in ./Result/benchmark/$date/Master/*/dstat_avg_result.txt
do
{
        val=0;
        val=`cat  $file | grep "receive:" | awk '{ print $2}'`
        sum=`echo "$sum + $val" | bc`
}
done

        avg=`echo "$sum / 3.00" | bc -l `
        echo "================Network usage:=============" >> ./Result/benchmark/$date/Master/dstat_avg_all.txt
        echo "receive:$avg" >> ./Result/benchmark/$date/Master/dstat_avg_all.txt


sum=0;
avg=0;

for file in ./Result/benchmark/$date/Master/*/dstat_avg_result.txt
do
{
        val=0;
        val=`cat  $file | grep "send:" | awk '{ print $2}'`
        sum=`echo "$sum + $val" | bc`
}
done

        avg=`echo "$sum / 3.00" | bc -l `
        echo "send:$avg" >> ./Result/benchmark/$date/Master/dstat_avg_all.txt

#=========================================Memory usage:-=========== 

sum=0;
avg=0;
for file in ./Result/benchmark/$date/Master/*/dstat_avg_result.txt
do
{
        val=0;
        val=`cat  $file | grep "used:" | awk '{ print $2}'`
        sum=`echo "$sum + $val" | bc`
}
done

        avg=`echo "$sum / 3.00" | bc -l `
        echo "============Memory usage:-=========== " >> ./Result/benchmark/$date/Master/dstat_avg_all.txt
        echo "used:$avg" >> ./Result/benchmark/$date/Master/dstat_avg_all.txt
#echo $avg

sum=0;
avg=0;

for file in ./Result/benchmark/$date/Master/*/dstat_avg_result.txt
do
{
        val=0;
        val=`cat  $file | grep "buffeded:" | awk '{ print $2}'`
        sum=`echo "$sum + $val" | bc`
}
done

        avg=`echo "$sum / 3.00" | bc -l `
        echo "buffeded:$avg" >> ./Result/benchmark/$date/Master/dstat_avg_all.txt


sum=0;
avg=0;
for file in ./Result/benchmark/$date/Master/*/dstat_avg_result.txt
do
{
        val=0;
        val=`cat  $file | grep "cached:" | awk '{ print $2}'`
        sum=`echo "$sum + $val" | bc`
}
done
	  avg=`echo "$sum / 3.00" | bc -l `
        echo "cached:$avg" >> ./Result/benchmark/$date/Master/dstat_avg_all.txt



#======================Disk usage:-=============

sum=0;
avg=0;
for file in ./Result/benchmark/$date/Master/*/dstat_avg_result.txt
do
{
        val=0;
        val=`cat  $file | grep "read:" | awk '{ print $2}'`
        sum=`echo "$sum + $val" | bc`
}
done

        avg=`echo "$sum / 3.00" | bc -l `
        echo "===============Disk usage:-============= " >> ./Result/benchmark/$date/Master/dstat_avg_all.txt
        echo "read:$avg" >> ./Result/benchmark/$date/Master/dstat_avg_all.txt



sum=0;
avg=0;
for file in ./Result/benchmark/$date/Master/*/dstat_avg_result.txt
do
{
        val=0;
        val=`cat  $file | grep "write:" | awk '{ print $2}'`
        sum=`echo "$sum + $val" | bc`
}
done

        avg=`echo "$sum / 3.00" | bc -l `
        echo "write:$avg" >> ./Result/benchmark/$date/Master/dstat_avg_all.txt



#==============================Disk utilization:-==========

sum=0;
avg=0;
for file in ./Result/benchmark/$date/Master/*/dstat_avg_result.txt
do
{
        val=0;
        val=`cat  $file | grep "util:" | awk '{ print $2}'`
        sum=`echo "$sum + $val" | bc`
}
done

        avg=`echo "$sum / 3.00" | bc -l `
        echo "=============Disk utilization:-========== " >> ./Result/benchmark/$date/Master/dstat_avg_all.txt
        echo "util:$avg" >> ./Result/benchmark/$date/Master/dstat_avg_all.txt

