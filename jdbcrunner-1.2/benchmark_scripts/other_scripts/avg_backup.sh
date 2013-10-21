#!/bin/bash


date=$1
server=$2
sum=0;
avg=0;
#=========cpu==================
for file in ./benchmark/$date/$server/*/bkp_avg_result.txt
do
{
        val=0;
        val=`cat  $file | grep "tx1:" | awk '{ print $2}'`
        sum=`echo "$sum + $val" | bc`
}
done

        avg=`echo "$sum / 3.00" | bc -l `
        echo "========Throughput During Backup:-============" > ./benchmark/$date/$server/bkp_avg_all.txt
        echo "tx1:$avg" >> ./benchmark/$date/$server/bkp_avg_all.txt

sum=0;
avg=0;


for file in ./benchmark/$date/$server/*/bkp_avg_result.txt
do
{
        val=0;
        val=`cat  $file | grep "tx2:" | awk '{ print $2}'`
        sum=`echo "$sum + $val" | bc`
}
done

        avg=`echo "$sum / 3.00" | bc -l `
        echo "tx2:$avg" >> ./benchmark/$date/$server/bkp_avg_all.txt


sum=0;
avg=0;


for file in ./benchmark/$date/$server/*/bkp_avg_result.txt
do
{
        val=0;
        val=`cat  $file | grep "tx3:" | awk '{ print $2}'`
        sum=`echo "$sum + $val" | bc`
}
done

        avg=`echo "$sum / 3.00" | bc -l `
        echo "tx3:$avg" >> ./benchmark/$date/$server/bkp_avg_all.txt



sum=0;
avg=0;


for file in ./benchmark/$date/$server/*/bkp_avg_result.txt
do
{
        val=0;
        val=`cat  $file | grep "tx4:" | awk '{ print $2}'`
        sum=`echo "$sum + $val" | bc`
}
done

        avg=`echo "$sum / 3.00" | bc -l `
        echo "tx4:$avg" >> ./benchmark/$date/$server/bkp_avg_all.txt


sum=0;
avg=0;


for file in ./benchmark/$date/$server/*/bkp_avg_result.txt
do
{
        val=0;
        val=`cat  $file | grep "tx5:" | awk '{ print $2}'`
        sum=`echo "$sum + $val" | bc`
}
done

        avg=`echo "$sum / 3.00" | bc -l `
        echo "tx5:$avg" >> ./benchmark/$date/$server/bkp_avg_all.txt


