#!/bin/bash

(

for file in Result/benchmark/*/Master/*/bkp_result.txt
do
{
	T1=`cat $file | grep "Backup from Master Start Time:" | awk '{print $6}' | cut -c 12-19 | sed -e 's/-/:/g'`
	T2=`cat $file | grep "Backup from Master Stop Time:" | awk '{print $6}' | cut -c 12-19 | sed -e 's/-/:/g'`

	h1=`echo $T1|cut -d: -f1`
	m1=`echo $T1|cut -d: -f2`
	s1=`echo $T1|cut -d: -f3`
	x1=`echo "$h1*3600 + $m1*60 + $s1"|bc -l`

	h2=`echo $T2|cut -d: -f1`
	m2=`echo $T2|cut -d: -f2`
	s2=`echo $T2|cut -d: -f3`

	x2=`echo "$h2*3600 + $m2*60 + $s2"|bc -l`


	if test $x1 -lt $x2
	then
		diff=`echo "$x2 - $x1"|bc -l`
	else
		diff=`echo "$x1 - $x2"|bc -l`
	fi


	echo "diff of $h1,$m1,$s1 and $h2,$m2,$s2 is $diff seconds"
	echo $file

	hours=$((diff / 3600))
	diff=$((diff % 3600))
	minutes=$((diff / 60))
	diff=$((diff % 60))

echo "Test Duration: $hours hour(s) $minutes minute(s) $diff second(s)" >> $file

}
done



for file in Result/benchmark/*/Standby-1/*/bkp_result.txt
do
{
	T1=`cat $file | grep "Backup from Standby-I Start Time:" | awk '{print $6}' | cut -c 12-19 | sed -e 's/-/:/g'`
	T2=`cat $file | grep "Backup from Standby-I Stop Time:" | awk '{print $6}' | cut -c 12-19 | sed -e 's/-/:/g'`

	h1=`echo $T1|cut -d: -f1`
	m1=`echo $T1|cut -d: -f2`
	s1=`echo $T1|cut -d: -f3`
	x1=`echo "$h1*3600 + $m1*60 + $s1"|bc -l`

	h2=`echo $T2|cut -d: -f1`
	m2=`echo $T2|cut -d: -f2`
	s2=`echo $T2|cut -d: -f3`

	x2=`echo "$h2*3600 + $m2*60 + $s2"|bc -l`


	if test $x1 -lt $x2
	then
		diff=`echo "$x2 - $x1"|bc -l`
	else
		diff=`echo "$x1 - $x2"|bc -l`
	fi


	echo "diff of $h1,$m1,$s1 and $h2,$m2,$s2 is $diff seconds"
	echo $file

	hours=$((diff / 3600))
	diff=$((diff % 3600))
	minutes=$((diff / 60))
	diff=$((diff % 60))

echo "Test Duration: $hours hour(s) $minutes minute(s) $diff second(s)" >> $file

}
done




for file in Result/benchmark/*/Standby-2/*/bkp_result.txt
do
{
	T1=`cat $file | grep "Backup from Standby-II Start Time:" | awk '{print $6}' | cut -c 12-19 | sed -e 's/-/:/g'`
	T2=`cat $file | grep "Backup from Standby-II Stop Time:" | awk '{print $6}' | cut -c 12-19 | sed -e 's/-/:/g'`

	h1=`echo $T1|cut -d: -f1`
	m1=`echo $T1|cut -d: -f2`
	s1=`echo $T1|cut -d: -f3`
	x1=`echo "$h1*3600 + $m1*60 + $s1"|bc -l`

	h2=`echo $T2|cut -d: -f1`
	m2=`echo $T2|cut -d: -f2`
	s2=`echo $T2|cut -d: -f3`

	x2=`echo "$h2*3600 + $m2*60 + $s2"|bc -l`


	if test $x1 -lt $x2
	then
		diff=`echo "$x2 - $x1"|bc -l`
	else
		diff=`echo "$x1 - $x2"|bc -l`
	fi


	echo "diff of $h1,$m1,$s1 and $h2,$m2,$s2 is $diff seconds"
	echo $file

	hours=$((diff / 3600))
	diff=$((diff % 3600))
	minutes=$((diff / 60))
	diff=$((diff % 60))

echo "Test Duration: $hours hour(s) $minutes minute(s) $diff second(s)" >> $file

}
done

) 2> error.log
