#!/bin/bash


count=1
while read nr wt mt na
do
	
        [ "$nr" == "NR" ] && continue                       # Skip the Header
	

	mkdir -p benchmark
        date=$(date +"%Y-%m-%d-%H-%M-%S")
        mkdir -p ./benchmark/$date
        mkdir -p ./benchmark/$date/Server1
#        mkdir -p ./benchmark/$date/Server2
#        mkdir -p ./benchmark/$date/Server3
	while [ $nr -gt 0 ]
        do
	        tdate=$(date +"%Y-%m-%d-%H-%M-%S")
		#ssh root@172.26.126.156 'dstat -tvn 1 100 --output stdout ' > ./benchmark/$date/dstatOutput/$tdate.csv  &
        mkdir -p ./benchmark/$date/Server1/Run$count/dstatOutput
		#dstat -td 1 100 --output stdout > ./benchmark/$date/Server1/Run$count/dstatOutput/$tdate.csv &
		#ssh sachin@172.26.126.156 'dstat -tcnmdls 1 100 --output stdout ' > ./benchmark/$date/Server1/Run$count/dstatOutput/$tdate.csv &
		ssh sachin@172.26.127.116 'dstat -tcnmdls --output test.csv 1 3610 1>/dev/null' &
		echo "Running Benchmark on Server-1"
	mkdir -p ./benchmark/$date/Server1/Run$count/jdbcRunnerLogs

	        java JR $1 -warmupTime $wt -measurementTime $mt -nAgents $na -jdbcUrl "jdbc:postgresql://172.26.127.116:5432/postgres" -logDir "./benchmark/$date/Server1/Run$count/jdbcRunnerLogs/">./benchmark/$date/Server1/Run$count/jdbcRunnerLogs/$tdate.txt    # Print values read in variable
		
		ssh sachin@172.26.127.116 'scp test.csv sachin@172.26.127.101:/home/sachin/jdbcrunner-1.2/'
		mv test.csv ./benchmark/$date/Server1/Run$count/dstatOutput/dstat.csv
#	        tdate=$(date +"%Y-%m-%d-%H-%M-%S")


#        mkdir -p ./benchmark/$date/Server2/Run$count/dstatOutput
#		ssh sachin@172.26.126.156 'dstat -tvn 1 100 --output stdout ' > ./benchmark/$date/Server2/Run$count/dstatOutput/$tdate.csv &
#		echo "Running Benchmark on Server-2"
#	mkdir -p ./benchmark/$date/Server2/Run$count/jdbcRunnerLogs

#	        java JR $1 -warmupTime $wt -measurementTime $mt -nAgents $na -jdbcUrl "jdbc:postgresql://172.26.126.156:5432/postgres" -logDir "./benchmark/$date/Server2/Run$count/jdbcRunnerLogs/">./benchmark/$date/Server2/Run$count/jdbcRunnerLogs/$tdate.txt    # Print values read in variable


#	        tdate=$(date +"%Y-%m-%d-%H-%M-%S")

#        mkdir -p ./benchmark/$date/Server3/Run$count/dstatOutput
#		ssh sachin@172.26.126.156 'dstat -tvn 1 100 --output stdout ' > ./benchmark/$date/Server3/Run$count/dstatOutput/$tdate.csv &
#		echo "Running Benchmark on Server-3"
#	mkdir -p ./benchmark/$date/Server3/Run$count/jdbcRunnerLogs

#	        java JR $1 -warmupTime $wt -measurementTime $mt -nAgents $na -jdbcUrl "jdbc:postgresql://172.26.126.156:5432/postgres" -logDir "./benchmark/$date/Server3/Run$count/jdbcRunnerLogs/">./benchmark/$date/Server3/Run$count/jdbcRunnerLogs/$tdate.txt    # Print values read in variable

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


#------------------------------------
#Add date instead of sec count in .dat file
#-----------------------------------
for file in ./benchmark/$date/*/*/jdbcRunnerLogs/*.txt
do
        #echo $file
        ts=`cat $file | grep " 1 sec" | awk '{print $1}'`
        echo $ts
	server=$(echo "$file" | cut -c 33-39)
	run=$(echo "$file" | cut -c 41-44)
	tfile=$(echo "$file" | cut -c 72-79)

#        for tfile in ./benchmark/$date/$server/$run/dstatOutput/*$tfile.csv
        for tfile in ./benchmark/$date/$server/$run/dstatOutput/dstat.csv
                do

                      #  echo $tfile
			server=$(echo "$tfile" | cut -c 33-39)
			run=$(echo "$file" | cut -c 41-44)
                        img=$(echo "$tfile" | cut -c 58-76)
		sed '/^"/ D; /^$/ D; s/,/ /g' $tfile > ./benchmark/$date/$server/$run/gnuInput/stat.dat


                   #     cat $tfile | sed 2d |awk 'BEGIN{ORS="";}{i=2; while(i<=NF) {print substr($i,1,8),"\t";i++;} print "\n";} ' | awk -v str=$ts '{if($1>=str) print $0}' | awk -v val=1 'BEGIN{ORS="";} {if(val<=90) {i=2; print val,"\t"; while(i<=NF) {print $i,"\t"; i=i+1; } print "\n";} val=val+1}' > ./benchmark/$date/$server/$run/gnuInput/stat.dat
                done

done
             
#--------------------------------
#for file in ./benchmark/$date/*/gnuInput/*.csv
#do
#	server=$(echo "$file" | cut -c 33-39)
#			pat=""
#	img1=$(echo "$tfile" | cut -c 63-71)
#	img2=$(echo $img1 | sed -e 's/-//g')
#	pat="$img2""_t.dat"
#echo $pat
#        for tfile in ./benchmark/$date/$server/gnuInput/*"$pat"
#                do
#                        img=$(echo "$tfile" | cut -c 54-68)
#			join $tfile $file > ./benchmark/$date/$server/gnuInput/$img.dat
#			break;
#		done
             
#done




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


#for file in ./benchmark/$date/*/*/gnuInput/*.csv
for file in ./benchmark/$date/*/*/gnuInput/stat.dat
do
gnuplot << EOF
#set   autoscale
set xlabel "Response Time \(seconds)"
set ylabel "Disk Write (in K)"
set grid
#set yrange [0:500]
set terminal png
set output "test.png"
#plot "$file"  using 1:3 title 'Disk Usage' with linespoints


set xdata time
set timefmt "%d-%m %H:%M:%S "
set format x "%H:%M:%S"
set xtics rotate autofreq


plot "$file"  using 1:15 title 'read' with lines, "$file" using 1:16 title 'write' with lines
#plot "$file"  using 1:(\$15/1000) title 'read' with lines, "$file" using 1:(\$16/1000) title 'write' with lines
EOF

server=$(echo "$file" | cut -c 33-39)
run=$(echo "$file" | cut -c 41-44)
img=$(echo "$file" | cut -c 55-73)
mkdir -p ./benchmark/$date/$server/$run/gnuPlot
mv test.png ./benchmark/$date/$server/$run/gnuPlot/dstat.png
#echo $file
done











done < benchmark.conf
