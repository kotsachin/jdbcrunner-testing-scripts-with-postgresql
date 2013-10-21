#!/bin/bash


count=1
while read nr wt mt na
do
	
        [ "$nr" == "NR" ] && continue                       # Skip the Header
	
echo "$nr:$wt:$mt:$na"

	mkdir -p benchmark
        date=$(date +"%Y-%m-%d-%H-%M-%S")
        mkdir -p ./benchmark/$date
        mkdir -p ./benchmark/$date/Server1
#        mkdir -p ./benchmark/$date/Server2
#        mkdir -p ./benchmark/$date/Server3
	while [ $nr -gt 0 ]
        do
	        tdate=$(date +"%Y-%m-%d-%H-%M-%S")
		echo "Running Benchmark on Server-1"
	mkdir -p ./benchmark/$date/Server1/Run$count/jdbcRunnerLogs

	        java JR $1 -warmupTime $wt -measurementTime $mt -nAgents $na -jdbcUrl "jdbc:postgresql://172.26.127.116:5432/tpcc" -logDir "./benchmark/$date/Server1/Run$count/jdbcRunnerLogs/">./benchmark/$date/Server1/Run$count/jdbcRunnerLogs/$tdate.txt    # Print values read in variable
	nr=$((nr-1))		
	count=$((count+1))
        done



#----------------------------
for file in ./benchmark/$date/*/*/jdbcRunnerLogs/*.csv
do
	server=$(echo "$file" | cut -c 33-39)
	run=$(echo "$file" | cut -c 41-44)
	img=$(echo "$file" | cut -c 65-81)
	mkdir -p ./benchmark/$date/$server/$run/gnuInput
	sed 's/,/\t/g' $file | sed 1d > ./benchmark/$date/$server/$run/gnuInput/$img.dat
done


             

#-----------------------------
#--Generate graph for each file in .png format under graphs directory.
# open .png files with gthumb in centos.
#----------------------------
for file in ./benchmark/$date/*/*/gnuInput/*_t.dat
do
gnuplot << EOF
set   autoscale
set xlabel "Elapsed Time \(seconds)"
set ylabel "Throughput (Number of transaction)"
set grid
#set yrange [0:500]
set terminal png
set output "test.png"
plot "$file"  using 1:2 title 'Transaction Type-1' with linespoints
EOF

server=$(echo "$file" | cut -c 33-39)
run=$(echo "$file" | cut -c 41-44)
img=$(echo "$file" | cut -c 55-71)
mkdir -p ./benchmark/$date/$server/$run/gnuPlot
mv test.png ./benchmark/$date/$server/$run/gnuPlot/$img.png
#echo $file
done

#------------------------

for file in ./benchmark/$date/*/*/gnuInput/*_r.dat
do
gnuplot << EOF
set   autoscale
set xlabel "Response Time \(miliseconds)"
set ylabel "Count (Number of transaction)"
set grid
#set yrange [0:500]
set terminal png
set output "test.png"
plot "$file"  using 1:2 title 'Transaction Type-1' with linespoints
EOF

server=$(echo "$file" | cut -c 33-39)
run=$(echo "$file" | cut -c 41-44)
img=$(echo "$file" | cut -c 55-71)
mkdir -p ./benchmark/$date/$server/$run/gnuPlot
mv test.png ./benchmark/$date/$server/$run/gnuPlot/$img.png
#echo $file
done
#-----------------------------------
#------------------------------------



done < benchmark.conf
