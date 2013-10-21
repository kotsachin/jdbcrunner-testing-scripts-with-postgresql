#!/bin/bash

exec<benchmark.conf
while read nr wt mt na
do	
count=1
        [ "$nr" == "NR" ] && continue                       # Skip the Header
	
	mkdir -p benchmark
        date=$(date +"%Y-%m-%d-%H-%M-%S")
        mkdir -p ./benchmark/$date
        mkdir -p ./benchmark/$date/Server1
#        mkdir -p ./benchmark/$date/Server2
#        mkdir -p ./benchmark/$date/Server3
	echo "Number of runs: $nr" > ./benchmark/$date/RUNCONF.txt
	echo "Warmup Time: $wt " >>  ./benchmark/$date/RUNCONF.txt
	echo "Measurement Time: $mt" >> ./benchmark/$date/RUNCONF.txt
	echo "Number of Agents: $na" >> ./benchmark/$date/RUNCONF.txt
	while [ $nr -gt 0 ]
        do
	        tdate=$(date +"%Y-%m-%d-%H-%M-%S")
		#ssh root@172.26.126.156 'dstat -tvn 1 100 --output stdout ' > ./benchmark/$date/dstatOutput/$tdate.csv  &
        mkdir -p ./benchmark/$date/Server1/Run$count/dstatOutput
		#dstat -td 1 100 --output stdout > ./benchmark/$date/Server1/Run$count/dstatOutput/$tdate.csv &
		#ssh sachin@172.26.126.156 'dstat -tcnmdls 1 100 --output stdout ' > ./benchmark/$date/Server1/Run$count/dstatOutput/$tdate.csv &
		ssh -n sachin@172.26.127.116 'rm -f test.csv'
		ssh -n sachin@172.26.127.116 'dstat -tcnmdls --output test.csv 1 3610 1>/dev/null' &
		#dstat -tcnmdls --output test.csv 1 20 1>/dev/null &
		echo "Running Benchmark on Server-1: Run $count"
	mkdir -p ./benchmark/$date/Server1/Run$count/jdbcRunnerLogs

	        java JR $1 -warmupTime $wt -measurementTime $mt -nAgents $na -jdbcUrl "jdbc:postgresql://172.26.127.116:5432/tpcc" -logDir "./benchmark/$date/Server1/Run$count/jdbcRunnerLogs/">./benchmark/$date/Server1/Run$count/jdbcRunnerLogs/$tdate.txt    # Print values read in variable
		sleep 15
		
		ssh -n sachin@172.26.127.116 'scp test.csv sachin@172.26.127.101:/home/sachin/jdbcrunner-1.2/'
		#echo $?	
		mv test.csv ./benchmark/$date/Server1/Run$count/dstatOutput/dstat.csv

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
		#sed '/^"/ D; /^$/ D; s/,/ /g' $tfile > ./benchmark/$date/$server/$run/gnuInput/stat.dat
		sed '/^"/ D; /^$/ D; s/,/ /g' $tfile | awk 'BEGIN{ORS="";}{i=2; while(i<=NF) {print substr($i,1,8),"\t";i++;} print "\n";} ' | awk -v str=$ts '{if($1>=str) print $0}' | awk -v val=1 'BEGIN{ORS="";} {if(val<=3600) {i=2; print val," "; while(i<=NF) {print $i," "; i=i+1; } print "\n";} val=val+1}' >  ./benchmark/$date/$server/$run/gnuInput/stat.dat

                   #     cat $tfile | sed 2d |awk 'BEGIN{ORS="";}{i=2; while(i<=NF) {print substr($i,1,8),"\t";i++;} print "\n";} ' | awk -v str=$ts '{if($1>=str) print $0}' | awk -v val=1 'BEGIN{ORS="";} {if(val<=90) {i=2; print val,"\t"; while(i<=NF) {print $i,"\t"; i=i+1; } print "\n";} val=val+1}' > ./benchmark/$date/$server/$run/gnuInput/stat.dat
                done

done
             


#-----------------------------
#--Generate graph for each file in .png format under graphs directory.
# open .png files with gthumb in centos.
#----------------------------
for file in ./benchmark/$date/*/*/gnuInput/*_t.dat
do
gnuplot << EOF
#set   autoscale
set xlabel "Elapsed Time \(seconds)"
set ylabel "Throughput (Number of transaction)"
#set grid
#set xtics rotate autofreq
#set ytics rotate autofreq
set yrange [0:500]
set terminal png
set output "test.png"
plot "$file" every 10::0 using 1:2 title 'Transaction Type-1' with lines
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
#set   autoscale
set xlabel "Response Time \(miliseconds)"
set ylabel "Count (Number of transaction)"
#set grid
#set xtics rotate autofreq
#set ytics rotate autofreq
set yrange [0:500]
set terminal png
set output "test.png"
plot "$file" every 10::0 using 1:2 title 'Transaction Type-1' with lines
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


server=$(echo "$file" | cut -c 33-39)
run=$(echo "$file" | cut -c 41-44)
img=$(echo "$file" | cut -c 55-73)
directory=$(echo "./benchmark/$date/$server/$run/gnuPlot")


# Make directory to store the results
setdir(){
  mkdir -p $directory
  cd $directory
}


#############################################
# MAIN BLOCK
#############################################
# Use GNU plot to plot the graph
graph () {
gnuplot << EOF
set autoscale
set terminal $fileType
#set xtics rotate autofreq
#set ytics rotate autofreq
set output $output
set title $title
set xlabel $xlabel
set ylabel $ylabel
plot ${plot[*]}
EOF
}

# Plot CPU usage
plotcpu(){
  fileType="png"
  output='"cpu.png"'
  title='"CPU usage"'
  xlabel='"time"'
  ylabel='"percent"'

  plot=( '"../gnuInput/stat.dat"' using 1:2 title '"user"' with lines,'"../gnuInput/stat.dat"' using 1:3 title '"system"' with lines,'"../gnuInput/stat.dat"' using 1:4 title '"idle"' with lines,'"../gnuInput/stat.dat"' using 1:5 title '"wait"' with lines )

  graph

}

# Plot memory usage
plotmem(){
  fileType="png"
  output='"memory.png"'
  title='"Memory usage"'
  xlabel='"time"'
  ylabel='"size(MB)"'

  plot=( '"../gnuInput/stat.dat"' using 1:\(\$11/1000000\) title '"used"' with lines,'"../gnuInput/stat.dat"' using 1:\(\$12/1000000\) title '"buff"' with lines, '"../gnuInput/stat.dat"' using 1:\(\$13/1000000\) title '"cach"' with lines,'"../gnuInput/stat.dat"' using 1:\(\$14/1000000\) title '"free"' with lines )

  graph
}

# Plot network usage
plotnet(){
  fileType="png"
  output='"network.png"'
  title='"Network usage"'
  xlabel='"time"'
  ylabel='"size(KB)"'

  plot=( '"../gnuInput/stat.dat"' using 1:\(\$8/1000\) title '"recv"' with lines,'"../gnuInput/stat.dat"' using 1:\(\$9/1000\) title '"send"' with lines )

  graph

}

# Plot disk usage
plotdisk(){
  fileType="png"
  output='"disk.png"'
  title='"Disk usage"'
  xlabel='"time"'
  ylabel='"size(KB)"'

  plot=( '"../gnuInput/stat.dat"' using 1:\(\$14/1000\) title '"read"' with lines,'"../gnuInput/stat.dat"' using 1:\(\$15/1000\) title '"writ"' with lines )

  graph

}

# Plot load average
plotload(){
  fileType="png"
  output='"load.png"'
  title='"Load average"'
  xlabel='"time"'
  ylabel='"load"'

  plot=( '"../gnuInput/stat.dat"' using 1:16 title '"1m"' with lines,'"../gnuInput/stat.dat"' using 1:17 title '"5m"' with lines,'"../gnuInput/stat.dat"' using 1:18 title '"15m"' with lines )

  graph

}

# Plot swap usage
plotswap(){
  fileType="png"
  output='"swap.png"'
  title='"Swap usage"'
  xlabel='"time"'
  ylabel='"size(MB)"'

  plot=( '"../gnuInput/stat.dat"' using 1:\(\$19/1000000\) title '"used"' with lines,'"../gnuInput/stat.dat"' using 1:\(\$20/1000000\) title '"free"' with lines )

  graph

}


setdir
#gendata

# Plot results
echo "Plot results into '$directory' directory"
plotmem
plotnet
plotcpu
plotdisk
plotload
plotswap

cd /home/sachin/jdbcrunner-1.2/
done 

done
