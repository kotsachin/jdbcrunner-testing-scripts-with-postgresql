#!/bin/bash -ex

date=$1
sum=0;
avg=0;

(

for file in  ./benchmark/$date/Master/*/jdbcRunnerLogs/*.txt 
do
{

	tps=`cat $file | grep "Throughput" | awk '{print $5}'`
	IFS=',' read -ra tp <<< "$tps"

    		tx=` echo "${tp[0]}"`
		sum=`echo "$sum + $tx" | bc`
}
done

        avg=`echo "$sum / 3.00" | bc -l `
        echo "=======Throughput==========" > ./benchmark/$date/Master/throughput_avg.txt
        echo "tx1:$avg" >> ./benchmark/$date/Master/throughput_avg.txt

sum=0;
avg=0;

for file in  ./benchmark/$date/Master/*/jdbcRunnerLogs/*.txt
do
{

        tps=`cat $file | grep "Throughput" | awk '{print $5}'`
        IFS=',' read -ra tp <<< "$tps"

                tx=` echo "${tp[1]}"`
                sum=`echo "$sum + $tx" | bc`
}
done

        avg=`echo "$sum / 3.00" | bc -l `
        echo "tx2:$avg" >> ./benchmark/$date/Master/throughput_avg.txt

sum=0;
avg=0;

for file in  ./benchmark/$date/Master/*/jdbcRunnerLogs/*.txt
do
{

        tps=`cat $file | grep "Throughput" | awk '{print $5}'`
        IFS=',' read -ra tp <<< "$tps"

                tx=` echo "${tp[2]}"`
                sum=`echo "$sum + $tx" | bc`
}
done

        avg=`echo "$sum / 3.00" | bc -l `
        echo "tx3:$avg" >> ./benchmark/$date/Master/throughput_avg.txt
        
sum=0;
avg=0

for file in  ./benchmark/$date/Master/*/jdbcRunnerLogs/*.txt
do
{

        tps=`cat $file | grep "Throughput" | awk '{print $5}'`
        IFS=',' read -ra tp <<< "$tps"

                tx=` echo "${tp[3]}"`
                sum=`echo "$sum + $tx" | bc`
}
done

        avg=`echo "$sum / 3.00" | bc -l `
        echo "tx4:$avg" >> ./benchmark/$date/Master/throughput_avg.txt

sum=0;
avg=0

for file in  ./benchmark/$date/Master/*/jdbcRunnerLogs/*.txt
do
{

        tps=`cat $file | grep "Throughput" | awk '{print $5}'`
        IFS=',' read -ra tp <<< "$tps"

                tx=` echo "${tp[4]}"`
                sum=`echo "$sum + $tx" | bc`
}
done

        avg=`echo "$sum / 3.00" | bc -l `
        echo "tx5:$avg" >> ./benchmark/$date/Master/throughput_avg.txt

#==============90 percentile======
sum=0;
avg=0

for file in  ./benchmark/$date/Master/*/jdbcRunnerLogs/*.txt 
do
{

	tps=`cat $file | grep "90%tile" | awk '{print $7}'`
	IFS=',' read -ra tp <<< "$tps"

    		tx=` echo "${tp[0]}"`
		sum=`echo "$sum + $tx" | bc`
}
done

        avg=`echo "$sum / 3.00" | bc -l `
        echo "=======90%tile response time==========" >> ./benchmark/$date/Master/throughput_avg.txt
        echo "tx1:$avg" >> ./benchmark/$date/Master/throughput_avg.txt

sum=0;
avg=0;

for file in  ./benchmark/$date/Master/*/jdbcRunnerLogs/*.txt
do
{

        tps=`cat $file | grep "90%tile" | awk '{print $7}'`
        IFS=',' read -ra tp <<< "$tps"

                tx=` echo "${tp[1]}"`
                sum=`echo "$sum + $tx" | bc`
}
done

        avg=`echo "$sum / 3.00" | bc -l `
        echo "tx2:$avg" >> ./benchmark/$date/Master/throughput_avg.txt

sum=0;
avg=0;

for file in  ./benchmark/$date/Master/*/jdbcRunnerLogs/*.txt
do
{

        tps=`cat $file | grep "90%tile" | awk '{print $7}'`
        IFS=',' read -ra tp <<< "$tps"

                tx=` echo "${tp[2]}"`
                sum=`echo "$sum + $tx" | bc`
}
done

        avg=`echo "$sum / 3.00" | bc -l `
        echo "tx3:$avg" >> ./benchmark/$date/Master/throughput_avg.txt
        
sum=0;
avg=0
for file in  ./benchmark/$date/Master/*/jdbcRunnerLogs/*.txt
do
{

        tps=`cat $file | grep "90%tile" | awk '{print $7}'`
        IFS=',' read -ra tp <<< "$tps"

                tx=` echo "${tp[3]}"`
                sum=`echo "$sum + $tx" | bc`
}
done

        avg=`echo "$sum / 3.00" | bc -l `
        echo "tx4:$avg" >> ./benchmark/$date/Master/throughput_avg.txt


sum=0;
avg=0
for file in  ./benchmark/$date/Master/*/jdbcRunnerLogs/*.txt
do
{

        tps=`cat $file | grep "90%tile" | awk '{print $7}'`
        IFS=',' read -ra tp <<< "$tps"

                tx=` echo "${tp[4]}"`
                sum=`echo "$sum + $tx" | bc`
}
done

        avg=`echo "$sum / 3.00" | bc -l `
        echo "tx5:$avg" >> ./benchmark/$date/Master/throughput_avg.txt



) 2> error.log

