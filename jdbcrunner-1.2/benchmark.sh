#!/bin/bash

	mkdir -p benchmark
        date=$(date +"%Y-%m-%d-%H-%M-%S")
        mkdir -p ./benchmark/$date
        mkdir -p ./benchmark/$date/Server1
        mkdir -p ./benchmark/$date/Server2
        mkdir -p ./benchmark/$date/Server3
        mkdir -p ./benchmark/$date/Server1/dstatOutput
        mkdir -p ./benchmark/$date/Server2/dstatOutput
        mkdir -p ./benchmark/$date/Server3/dstatOutput
	mkdir -p ./benchmark/$date/Server1/jdbcRunnerLogs
	mkdir -p ./benchmark/$date/Server2/jdbcRunnerLogs
	mkdir -p ./benchmark/$date/Server3/jdbcRunnerLogs

count=-1
while read nr wt mt na
do
	count=$((count+1))
	
        [ "$nr" == "NR" ] && continue                       # Skip the Header
	while [ $nr -gt 0 ]
        do
        tdate=$(date +"%Y-%m-%d-%H-%M-%S")
	#ssh root@172.26.126.151 'dstat -tvn 1 100 --output stdout ' > ./benchmark/$date/dstatOutput/$tdate.csv  &
	dstat -tc 1 100 --output stdout > ./benchmark/$date/Server1/dstatOutput/$date.csv &
	echo "Running Benchmark...1"
        java JR $1 -warmupTime $wt -measurementTime $mt -nAgents $na -jdbcUrl "jdbc:postgresql://172.26.126.38:5432/postgres" > ./benchmark/$date/Server1/jdbcRunnerLogs/$tdate.log    # Print values read in variable
	dstat -tc 1 100 --output stdout > ./benchmark/$date/Server2/dstatOutput/$date.csv &
	echo "Running Benchmark...2"
        java JR $1 -warmupTime $wt -measurementTime $mt -nAgents $na -jdbcUrl "jdbc:postgresql://172.26.126.38:5432/postgres" > ./benchmark/$date/Server2/jdbcRunnerLogs/$tdate.log    # Print values read in variable
	dstat -tc 1 100 --output stdout > ./benchmark/$date/Server3/dstatOutput/$date.csv &
	echo "Running Benchmark...3"
        java JR $1 -warmupTime $wt -measurementTime $mt -nAgents $na -jdbcUrl "jdbc:postgresql://172.26.126.38:5432/postgres" > ./benchmark/$date/Server3/jdbcRunnerLogs/$tdate.log    # Print values read in variable
	nr=$((nr-1))
        done


#------------------------
#--Format log files to input for gnuplot(',' teplace by tab)
#output files in .dat format
#---------------------------
for file in ./logs/*.csv
do
#date=$(echo "$file" | cut -c 12-19)
#mkdir -p ./benchmark/$date/Round$count


img=$(echo "$file" | cut -c 12-28)
#mkdir -p ./benchmark/$img
mkdir -p ./benchmark/$date/gnuInput

sed 's/,/\t/g' $file > ./benchmark/$date/gnuInput/$img.dat
#echo $file
done
mv -f ./logs/*.csv ./benchmark/$date/jdbcRunnerLogs
#------------------------------------------------------------



#------------------------------------
#Add date instead of sec count in .dat file
#-----------------------------------
for file in ./benchmark/$date/dstatOutput/*.log
do
        #echo $file
        ts=`cat $file | grep " 1 sec" | awk '{print $1}'`
        echo $ts

        for tfile in ./benchmark/$date/dstatOutput/*.csv
                do

                        echo $tfile
                        img=$(echo "$tfile" | cut -c 45-63)
                        cat $tfile | sed 2d |awk 'BEGIN{ORS="";}{i=2; while(i<=NF) {print substr($i,1,8),"\t";i++;} print "\n";} ' | awk -v str=$ts '{if($1>=str) print $0}' | awk -v val=1 'BEGIN{ORS="";} {if(val<=90) {i=2; print val,"\t"; while(i<=NF) {print $i,"\t"; i=i+1; } print "\n";} val=val+1}' > ./benchmark/$date/gnuInput/$img.csv
#awk 'BEGIN{ORS="";}{i=2; while(i<=NF) { if print $i,"\t";i++;} print "\n";} '
                        #cat $tfile | sed 1d | awk -v val=23 '{print val,$2; val=val+1}'
                done

done


#-----------------------------
#--Generate graph for each file in .png format under graphs directory.
# open .png files with gthumb in centos.
#----------------------------
for file in ./benchmark/$date/gnuInput/*_t.dat
do
gnuplot << EOF
set   autoscale
set xlabel "Elapsed Time \(seconds)"
set ylabel "Throughput (Number of transaction)"
set grid
set yrange [0:2000]
set terminal png
set output "test.png"
plot "$file"  using 1:2 title 'Transaction Type-1' with linespoints
EOF

img=$(echo "$file" | cut -c 42-58)
mkdir -p ./benchmark/$date/gnuPlot
mv test.png ./benchmark/$date/gnuPlot/$img.png
#echo $file
done

#------------------------

for file in ./benchmark/$date/gnuInput/*_r.dat
do
gnuplot << EOF
set   autoscale
set xlabel "Response Time \(miliseconds)"
set ylabel "Count (Number of transaction)"
set grid
set yrange [0:2000]
set terminal png
set output "test.png"
plot "$file"  using 1:2 title 'Transaction Type-1' with linespoints
EOF

img=$(echo "$file" | cut -c 42-58)
mkdir -p ./benchmark/$date/gnuPlot
mv test.png ./benchmark/$date/gnuPlot/$img.png
#echo $file
done
#-----------------------------------
#------------------------------------


done < benchmark.conf
