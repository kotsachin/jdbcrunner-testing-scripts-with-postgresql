for file in Result/benchmark/*/*/*/bkp_result.txt
do
{
        T1=`cat $file | grep "Backup from Master Start Time:"`
        T2=`cat $file | grep "Backup from Master Stop Time:"`
        T3=`cat $file | grep "Total backup size:"`
	echo "$T1" > $file
	echo "$T2" >> $file
	echo "$T3" >> $file

}
done
