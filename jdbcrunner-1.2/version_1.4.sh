#!/bin/bash

#----THIS PROGRAM IS WRAPPER ON TOP OF THE JDBCRUNNER TOOL USED FOR BENCHMARKING OF DIFFERNENT DATABASES LIKE POSTGRES,ORACLE,MYSQL ETC.----
#--IN THIS WRAPPER WE CAN SET THE CONFIGURABLE PARAMETSRS OF THE JDBCRUNNER AND RUN THE TEST OVER NIGHT.

OLD=100

exec<benchmark.conf
while read nr wt mt na scl cs st1 st2 st3 st4 st5 #reading parameters from benchmark.conf file
do
	
count=1
        [ "$nr" == "NR" ] && continue                       # Skip the Header
	
	mkdir -p benchmark
        date=$(date +"%Y-%m-%d-%H-%M-%S")
        mkdir -p ./benchmark/$date
        mkdir -p ./benchmark/$date/Server1
#        mkdir -p ./benchmark/$date/Server2
#        mkdir -p ./benchmark/$date/Server3
	echo "Start time of benchmark: $date"

	echo "Number of runs: $nr" 
	echo "Warmup Time: $wt " 
	echo "Measurement Time: $mt" 
	echo "Number of Agents: $na" 
	echo "Scale: $scl"
	#echo "shared_buffers: $sb"
	#echo "full_page_writes: $fpw"
	echo "checkpoint_segments: $cs" 
	#echo "archive_mode: $ar" 
	echo "Sleep Times: $st1, $st2, $st3, $st4, $st5" 

	echo "Number of runs: $nr" > ./benchmark/$date/RUNCONF.txt
	echo "Warmup Time: $wt " >>  ./benchmark/$date/RUNCONF.txt
	echo "Measurement Time: $mt" >> ./benchmark/$date/RUNCONF.txt
	echo "Number of Agents: $na" >> ./benchmark/$date/RUNCONF.txt
	echo "Scale: $scl" >> ./benchmark/$date/RUNCONF.txt
	#echo "shared_buffers: $sb" >> ./benchmark/$date/RUNCONF.txt
	#echo "full_page_writes: $fpw" >> ./benchmark/$date/RUNCONF.txt
	echo "checkpoint_segments: $cs" >> ./benchmark/$date/RUNCONF.txt
	#echo "archive_mode: $ar" >> ./benchmark/$date/RUNCONF.txt
	echo "Sleep Times: $st1, $st2, $st3, $st4, $st5" >> ./benchmark/$date/RUNCONF.txt

#-----Changes postresql.conf file parameters---

	#ssh sachin@172.26.139.4 <<EOF
	#cat /db/pgsql922-5432/postgresql.conf | awk '{if(\$1=="checkpoint_segments")  print \$1,\$2,"$cs",\$4,\$5; else print \$0}' > temp.conf
	#mv temp.conf /db/pgsql922-5432/postgresql.conf
	#cat /db/pgsql922-5432/postgresql.conf | awk '{if(\$1=="archive_mode")  print \$1,\$2,"$ar"; else print \$0}' > temp.conf
	#mv temp.conf /db/pgsql922-5432/postgresql.conf
	#cat /db/pgsql922-5432/postgresql.conf | awk '{if(\$1=="full_page_writes")  print \$1,\$2,"$fpw"; else print \$0}' > temp.conf
        #mv temp.conf /db/pgsql922-5432/postgresql.conf
	#rm -f temp.conf
#EOF


#---------Starts Loading data of scale factors-----------
	echo "old scale: $OLD"
#	sleep 60
	echo "Loading benchmark data with scale : $scl"


		echo "Starting DB server..."

                ssh -n sachin@172.26.139.4 '/usr/pgsql-9.2/bin/pg_ctl -D /db/pgsql922-5432/ start 1>/dev/null'

                started="no"
		#--Waiting to start to database----
                while [ "$started" == "no" ]
                do
                        status=`ssh -n sachin@172.26.139.4 '/usr/pgsql-9.2/bin/pg_ctl -D /db/pgsql922-5432 status' | awk '{print $2}'`
                        status=`echo $status | awk '{print $1}'`
                        if [ "$status" == "server" ]
                        then
                                ssh -n sachin@172.26.139.4 "ps -ef | grep postgres | grep recovering | grep -v bash" 1>/dev/null
                                if [ $? == 1 ]
                                then
                                        started="yes"
                                fi
                        fi
                done
                echo "DB Server started."
                sleep 10
		#---jdbcrunner data loading command--------
		#java JR ./scripts/tpcc_load.js -jdbcUrl "jdbc:postgresql://172.26.139.4:5432/tpcc" -param0 $scl 1>/dev/null
		
		echo "Stopping DB server..."
                ssh -n sachin@172.26.139.4 '/usr/pgsql-9.2/bin/pg_ctl -D /db/pgsql922-5432 stop 1>/dev/null 2>/dev/null '

                stopped="no"
		#--Waiting to stop database---------
                while [ "$stopped" == "no" ]
                do
                        status=`ssh -n sachin@172.26.139.4 '/usr/pgsql-9.2/bin/pg_ctl -D /db/pgsql922-5432 status' | awk '{print $2}'`
                        if [ "$status" == "no" ]
                        then   
                                stopped="yes"
                        fi
                done

                echo "DB Server stopped."
		
		sleep 10
 

        OLD=$scl

#---------Finish with loading data according to scaling factor---------	
 
	while [ $nr -gt 0 ]
        do
		echo "Starting DB server..."

		ssh -n sachin@172.26.139.4 '/usr/pgsql-9.2/bin/pg_ctl -D /db/pgsql922-5432/ start 1>/dev/null'

		started="no"
		#----Waiting to start to database------
		while [ "$started" == "no" ]
		do
			status=`ssh -n sachin@172.26.139.4 '/usr/pgsql-9.2/bin/pg_ctl -D /db/pgsql922-5432 status' | awk '{print $2}'`
			status=`echo $status | awk '{print $1}'`
			if [ "$status" == "server" ]
			then
				ssh -n sachin@172.26.139.4 "ps -ef | grep postgres | grep recovering | grep -v bash" 1>/dev/null
                                if [ $? == 1 ]
                                then
                                        started="yes"
                                fi
			fi
		done
		echo "DB Server started."
		sleep 10
	        
		tdate=$(date +"%Y-%m-%d-%H-%M-%S")
		
		#-----Creating basic directories-----
        	mkdir -p ./benchmark/$date/Server1/Run$count/dstatOutput
		mkdir -p ./benchmark/$date/Server1/Run$count/jdbcRunnerLogs
		mkdir -p ./benchmark/$date/Server1/Run$count/pg_stats_info

		dcount=$((wt+mt+10)) #---calculating count for dstat --
		#-------Removing old dstat csv files--
		ssh -n sachin@172.26.139.4 'rm -f test.csv'
		rm -f test_local.csv

		#----Start to run dstat command in background-------
		ssh -n sachin@172.26.139.4 "dstat -D sda2,sda3,sda5,sda -tcnmdls --disk-util --output test.csv 1 $dcount 1>/dev/null" &

	#	dstat -tcnmdls --output test.csv 1 $dcount 1>/dev/null &
		dstat -D sda2,sda3,sda5,sda -tcnmdls --disk-util --output test_local.csv 1 $dcount 1>/dev/null &
		echo "Running Benchmark on Server-1: Run $count"

		#------command to run jdbcrunner benchmark test----

	        java JR $1 -warmupTime $wt -measurementTime $mt -nAgents $na -sleepTime $st1,$st2,$st3,$st4,$st5 -jdbcUrl "jdbc:postgresql://172.26.137.4:5432/tpcc" -logDir "./benchmark/$date/Server1/Run$count/jdbcRunnerLogs/" >./benchmark/$date/Server1/Run$count/jdbcRunnerLogs/$tdate.txt    # Print values read in variable
		sleep 15
		
		ssh -n sachin@172.26.139.4 'scp test.csv sachin@172.26.139.1:/home/sachin/jdbcrunner-1.2/'
			
		mv test.csv ./benchmark/$date/Server1/Run$count/dstatOutput/dstat.csv
		mv test_local.csv ./benchmark/$date/Server1/Run$count/dstatOutput/dstat_local.csv
       
		# clear archive directory
	#	if [ "$ar" == "on" ]
	#	then
	#		 ssh -n sachin@172.26.139.4 'rm -rf /archive/pgsql922-5432/*'
	#	fi

		#--------------Data from pg_stats_info----------
                startts="$ts"
                endts=`cat ./benchmark/"$date"/Server1/Run"$count"/jdbcRunnerLogs/jdbcrunner.log | grep "Total tx count" | awk '{print $1, $2}'`
		echo "$startts"
		echo "$ebdts"
		
                snapids=`psql -h 172.26.139.4 -d postgres -c "copy (select min(snapid),max(snapid) from statsrepo.snapshot where time between '$startts'::timestamp and '$endts'::timestamp) to stdout with delimiter ' '"`
                min=`echo $snapids | awk '{print $1}'`
                max=`echo $snapids | awk '{print $2}'`
                psql -h 172.26.139.4 -d postgres -c "copy (select to_char(time::time,'HH:MI:SS'), x.* from statsrepo.snapshot sn, statsrepo.database x where x.snapid between $min and $max and x.snapid=sn.snapid and name='tpcc') to stdout with delimiter ' '" > ./benchmark/$date/Server1/Run$count/pg_stats_info/dbstats.csv


		# stop the postgreSQL server
		echo "Stopping DB server..."
		ssh -n sachin@172.26.139.4 '/usr/pgsql-9.2/bin/pg_ctl -D /db/pgsql922-5432 stop 1>/dev/null 2>/dev/null '

		stopped="no"
		while [ "$stopped" == "no" ]
		do
			status=`ssh -n sachin@172.26.139.4 '/usr/pgsql-9.2/bin/pg_ctl -D /db/pgsql922-5432 status' | awk '{print $2}'`
			if [ "$status" == "no" ]
			then
 		       		stopped="yes"
			fi
		done

		echo "DB Server stopped."

		# clear archive directory
		ssh -n sachin@172.26.139.4 'rm -rf /archive/pgsql922-5432/*'

	 	# Retrieve the PostgreSQL log
		fl=`ssh -n sachin@172.26.139.4 'ls -lt  /var/log/pgsql-9.2/*.csv | head -n 1' | awk '{print \$NF}'`
		ssh -n sachin@172.26.139.4 "scp $fl sachin@172.26.139.5:/home/sachin/jdbcrunner-1.2/benchmark/$date/Server1/Run$count/$fl"
		
		nr=$((nr-1))
		count=$((count+1))
	done



#----------------------------Formating jdbcrunner csv files---
	for file in ./benchmark/$date/*/*/jdbcRunnerLogs/*_r.csv
	do
		server=$(echo "$file" | cut -c 33-39)
		run=$(echo "$file" | cut -c 41-44)
		img=$(echo "$file" | cut -c 65-81)
		mkdir -p ./benchmark/$date/$server/$run/gnuInput
		sed 's/,/\t/g' $file | sed 1d > ./benchmark/$date/$server/$run/gnuInput/$img.dat
	done

	for file in ./benchmark/$date/*/*/jdbcRunnerLogs/*_t.csv
	do
		server=$(echo "$file" | cut -c 33-39)
		run=$(echo "$file" | cut -c 41-44)
		img=$(echo "$file" | cut -c 65-81)
		mkdir -p ./benchmark/$date/$server/$run/gnuInput
		#sed 's/,/\t/g' $file | sed 1d > ./benchmark/$date/$server/$run/gnuInput/$img.dat
		cat $file | sed 1d | sed s/','/' '/g | awk '{print $2, $3, $4, $5, $6}' | ./movavg 10 | awk 'BEGIN{ line=1;}{print line,"\t", $0; line=line+1;}' > ./benchmark/$date/$server/$run/gnuInput/$img.dat
	done

#------------------------------------
#Add second instead of data and time  count in .dat file for remote dstat
#-----------------------------------
	for file in ./benchmark/$date/*/*/jdbcRunnerLogs/*.txt
	do
        	ts=`cat $file | grep " 1 sec" | awk '{print $1}'`
  	 #     echo $ts
		server=$(echo "$file" | cut -c 33-39)
		run=$(echo "$file" | cut -c 41-44)
		tfile=$(echo "$file" | cut -c 72-79)

#-----Creating result file----

cat  $file | grep -e "Response\|Total\|Throughput"  | cut -c 18-74 | \
awk \
'{ \
	if( $3 == "count]" )\
	{\
		print "TX-1 (New-Order) Total Count: ",substr($4,1,index($4,",")-1)\
	}\
	if($1 == "[Throughput]" )\
	{\
		print "TX-1 (New-Order) Throughput: ",substr($2,1,index($2,",")-1)\
	}\
	if($3 == "(minimum)]" )\
	{\
		print "TX-1 (New-Order) min RT: ",substr($4,1,index($4,",")-1), " msec"\
	}\
	if($3 == "(50%tile)]" )\
        {\
                print "TX-1 (New-Order) 50%tile RT: ",substr($4,1,index($4,",")-1), " msec"\
        }\
	if($3 == "(90%tile)]" )\
        {\
                print "TX-1 (New-Order) 90%tile RT: ",substr($4,1,index($4,",")-1), " msec"\
        }\
	if($3 == "(95%tile)]" )\
        {\
                print "TX-1 (New-Order) 95%tile RT: ",substr($4,1,index($4,",")-1), " msec"\
        }\
	if($3 == "(99%tile)]" )\
        {\
                print "TX-1 (New-Order) 99%tile RT: ",substr($4,1,index($4,",")-1), " msec"\
        }\
	if($3 == "(maximum)]" )\
        {\
                print "TX-1 (New-Order) max RT: ",substr($4,1,index($4,",")-1), " msec"\
        }\
}' >> ./benchmark/$date/$server/$run/RESULT.txt
		

        	for tfile in ./benchmark/$date/$server/$run/dstatOutput/dstat.csv
                do

			server=$(echo "$tfile" | cut -c 33-39)
			run=$(echo "$file" | cut -c 41-44)
                        img=$(echo "$tfile" | cut -c 58-76)
			#sed '/^"/ D; /^$/ D; s/,/ /g' $tfile > ./benchmark/$date/$server/$run/gnuInput/stat.dat
			sed '/^"/ D; /^$/ D; s/,/ /g' $tfile | awk 'BEGIN{ORS="";}{i=2; while(i<=NF) {print substr($i,1,8),"\t";i++;} print "\n";} ' | awk -v str=$ts '{if($1>=str) print $0}' | awk -v val=1 -v mtcnt=$mt 'BEGIN{ORS="";} {if(val<=mtcnt) {i=2; print val," "; while(i<=NF) {print $i," "; i=i+1; } print "\n";} val=val+1}' >  ./benchmark/$date/$server/$run/gnuInput/stat.dat

                done

	done


#------------------------------------
#Add second instead of data and time  count in .dat file for Local dstat
#-----------------------------------

	for file in ./benchmark/$date/*/*/jdbcRunnerLogs/*.txt
	do
        	ts=`cat $file | grep " 1 sec" | awk '{print $1}'`
       	# 	echo $ts
       		server=$(echo "$file" | cut -c 33-39)
     		run=$(echo "$file" | cut -c 41-44)
      		tfile=$(echo "$file" | cut -c 72-79)

       		 for tfile in ./benchmark/$date/$server/$run/dstatOutput/dstat_local.csv
                do

                        server=$(echo "$tfile" | cut -c 33-39)
                        run=$(echo "$file" | cut -c 41-44)
                        img=$(echo "$tfile" | cut -c 58-76)
                	#sed '/^"/ D; /^$/ D; s/,/ /g' $tfile > ./benchmark/$date/$server/$run/gnuInput/stat.dat
               		sed '/^"/ D; /^$/ D; s/,/ /g' $tfile | awk 'BEGIN{ORS="";}{i=2; while(i<=NF) {print substr($i,1,8),"\t";i++;} print "\n";} ' | awk -v str=$ts '{if($1>=str) print $0}' | awk -v val=1 -v mtcnt=$mt 'BEGIN{ORS="";} {if(val<=mtcnt) {i=2; print val," "; while(i<=NF) {print $i," "; i=i+1; } print "\n";} val=val+1}' >  ./benchmark/$date/$server/$run/gnuInput/stat_local.dat

                done

	done
            


#-----------------------------
#--Generate graph for each file in .png format under graphs directory.
# open .png files with gthumb in centos.
#----------------------------
	for file in ./benchmark/$date/*/*/gnuInput/*_t.dat
	do
	server=$(echo "$file" | cut -c 33-39)
	run=$(echo "$file" | cut -c 41-44)
	img=$(echo "$file" | cut -c 55-71)

	mkdir -p ./benchmark/$date/$server/$run/gnuPlot

	   graph () {
gnuplot << EOF
	set size 1,1
        set terminal $fileType size 840,480
        set output $output
	set key outside right top vertical Right noreverse enhanced autotitles box linetype -1 linewidth 1.000
        set title $title
        set xlabel $xlabel
        set ylabel $ylabel
	set lmargin at screen 0.10
	set rmargin at screen 0.70
	set yrange [0:500]
        plot ${plot[*]}
EOF
        }
	plot1_t(){
                fileType="png"
                output='"TransactionType-1_t.png"'
                title='"tx1 : New-Order transaction | sleep time: '$st1'"'
                xlabel='"Elapsed Time \(seconds)"'
                ylabel='"Throughput (Number of transaction)"'
                plot=( '"'$file'"'  using 1:2 title '"Transaction Type-1"' with points pointtype 7 pointsize 0.5  )
                graph
        }
	plot1_t
	mv TransactionType-1_t.png ./benchmark/$date/$server/$run/gnuPlot/TransactionType-1_t.png

	plot2_t(){
                fileType="png"
                output='"TransactionType-2_t.png"'
                title='"tx2 : Payment transaction | steep time: '$st2'"'
                xlabel='"Elapsed Time \(seconds)"'
                ylabel='"Throughput (Number of transaction)"'
                plot=( '"'$file'"'  using 1:3 title '"Transaction Type-2"' with points pointtype 7 pointsize 0.5  )
                graph
        }
	plot2_t
	mv TransactionType-2_t.png ./benchmark/$date/$server/$run/gnuPlot/TransactionType-2_t.png

	plot3_t(){
                fileType="png"
                output='"TransactionType-3_t.png"'
                title='"tx3 : Order-Status transaction | sleep time: '$st3'"'
                xlabel='"Elapsed Time \(seconds)"'
                ylabel='"Throughput (Number of transaction)"'
                plot=( '"'$file'"'  using 1:4 title '"Transaction Type-3"' with points pointtype 7 pointsize 0.5  )
                graph
        }
	plot3_t
	mv TransactionType-3_t.png ./benchmark/$date/$server/$run/gnuPlot/TransactionType-3_t.png


	plot4_t(){
                fileType="png"
                output='"TransactionType-4_t.png"'
                title='"tx4 : Delivery transaction | sleep time: '$st4'"'
                xlabel='"Elapsed Time \(seconds)"'
                ylabel='"Throughput (Number of transaction)"'
                plot=( '"'$file'"'  using 1:5 title '"Transaction Type-4"' with points pointtype 7 pointsize 0.5  )
                graph
        }
	plot4_t
	mv TransactionType-4_t.png ./benchmark/$date/$server/$run/gnuPlot/TransactionType-4_t.png

	plot5_t(){
                fileType="png"
                output='"TransactionType-5_t.png"'
                title='"tx5 : Stock-Level transaction | sleep time: '$st5'"'
                xlabel='"Elapsed Time \(seconds)"'
                ylabel='"Throughput (Number of transaction)"'
                plot=( '"'$file'"'  using 1:6 title '"Transaction Type-5"' with points pointtype 7 pointsize 0.5  )
                graph
        }
	plot5_t
	mv TransactionType-5_t.png ./benchmark/$date/$server/$run/gnuPlot/TransactionType-5_t.png


	done

#-----------------------------------------------------------------

	for file in ./benchmark/$date/*/*/gnuInput/*_r.dat
	do
	server=$(echo "$file" | cut -c 33-39)
	run=$(echo "$file" | cut -c 41-44)
	img=$(echo "$file" | cut -c 55-71)
	mkdir -p ./benchmark/$date/$server/$run/gnuPlot

	   graph () {
gnuplot << EOF
        set terminal $fileType size 840,480
        set output $output
	set size 1,1
	set lmargin at screen 0.10
	set rmargin at screen 0.70
	set key outside right top vertical Right noreverse enhanced autotitles box linetype -1 linewidth 1.000
        set title $title
        set xlabel $xlabel
        set ylabel $ylabel
	set yrange [0:500]
        plot ${plot[*]}
EOF
        }
	plot1_r(){
                fileType="png"
                output='"TransactionType-1_r.png"'
                title='"tx1 : New-Order transaction | sleep time: '$st1'"'
                xlabel='"Response Time \(seconds)"'
                ylabel='"Count (Number of transaction)"'
                plot=( '"'$file'"'  using\(\$1/1000\):2 title '"Transaction Type-1"' with points pointtype 7 pointsize 0.5  )
                graph
        }
	plot1_r
	mv TransactionType-1_r.png ./benchmark/$date/$server/$run/gnuPlot/TransactionType-1_r.png

	plot2_r(){
                fileType="png"
                output='"TransactionType-2_r.png"'
                title='"tx2 : Payment transaction | sleep time: '$st2'"'
                xlabel='"Response Time \(seconds)"'
                ylabel='"Count (Number of transaction)"'
                plot=( '"'$file'"'  using \(\$1/1000\):3 title '"Transaction Type-2"' with points pointtype 7 pointsize 0.5  )
                graph
        }
	plot2_r
	mv TransactionType-2_r.png ./benchmark/$date/$server/$run/gnuPlot/TransactionType-2_r.png

	plot3_r(){
                fileType="png"
                output='"TransactionType-3_r.png"'
                title='"tx3 : Order-Status transaction | sleep time :'$st3'"'
                xlabel='"Response Time \(seconds)"'
                ylabel='"Count (Number of transaction)"'
                plot=( '"'$file'"'  using \(\$1/1000\):4 title '"Transaction Type-3"' with points pointtype 7 pointsize 0.5  )
                graph
        }
	plot3_r
	mv TransactionType-3_r.png ./benchmark/$date/$server/$run/gnuPlot/TransactionType-3_r.png

	plot4_r(){
                fileType="png"
                output='"TransactionType-4_r.png"'
                title='"tx4 : Delivery transaction | sleep time: '$st4'"'
                xlabel='"Response Time \(seconds)"'
                ylabel='"Count (Number of transaction)"'
                plot=( '"'$file'"'  using \(\$1/1000\):5 title '"Transaction Type-4"' with points pointtype 7 pointsize 0.5  )
                graph
        }
	plot4_r
	mv TransactionType-4_r.png ./benchmark/$date/$server/$run/gnuPlot/TransactionType-4_r.png

	plot5_r(){
                fileType="png"
                output='"TransactionType-5_r.png"'
                title='"tx5 : Stock-Level transaction | sleep time: '$st5'"'
                xlabel='"Response Time \(seconds)"'
                ylabel='"Count (Number of transaction)"'
                plot=( '"'$file'"'  using \(\$1/1000\):6 title '"Transaction Type-5"' with points pointtype 7 pointsize 0.5  )
                graph
        }
	plot5_r
	mv TransactionType-5_r.png ./benchmark/$date/$server/$run/gnuPlot/TransactionType-5_r.png


	done

#-------------Printing Server Machine Dstat----------------------

	for file in ./benchmark/$date/*/*/gnuInput/stat.dat
	do
		server=$(echo "$file" | cut -c 33-39)
		run=$(echo "$file" | cut -c 41-44)
		img=$(echo "$file" | cut -c 55-68)


# Make directory to store the results
		setdir(){
			directory=$(echo "./benchmark/$date/$server/$run/gnuPlot/ServerMachineDstat")
  			mkdir -p $directory
  			cd $directory

		}


#############################################
# MAIN BLOCK
#############################################
# Use GNU plot to plot the graph
	graph () {
gnuplot << EOF
	set terminal $fileType size 840,480
	set size 1,1
	set lmargin at screen 0.10
	set rmargin at screen 0.70
	set key outside right top vertical Right noreverse enhanced autotitles box linetype -1 linewidth 1.000
	set output $output
	set title $title
	set xlabel $xlabel
	set ylabel $ylabel
	set yrange $yrange
	plot ${plot[*]}
EOF
	}

# Plot CPU usage
	plotcpu(){
 		fileType="png"
  		output='"cpu.png"'
  		title='"CPU Usage"'
  		xlabel='"time"'
  		ylabel='"percent"'
		yrange='[0:100]'

  		plot=( '"../../gnuInput/'$img'"'  using 1:2 title '"user"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:3 title '"system"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:4 title '"idle"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"' using 1:5 title '"iowait"' with points pointtype 7 pointsize 0.5  )

  		graph
	}

# Plot memory usage
	plotmem(){
  		fileType="png"
  		output='"memory.png"'
  		title='"Memory Usage"'
  		xlabel='"time"'
  		ylabel='"size(MB)"'
		yrange='[0:100]'

  		plot=( '"../../gnuInput/'$img'"'  using 1:\(\$10/1000000\) title '"used"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$11/1000000\) title '"buff"' with points pointtype 7 pointsize 0.5 , '"../../gnuInput/'$img'"'  using 1:\(\$12/1000000\) title '"cach"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$13/1000000\) title '"free"' with points pointtype 7 pointsize 0.5  )

  		graph
	}

# Plot network usage
	plotnet(){
  		fileType="png"
  		output='"network.png"'
  		title='"Network Usage"'
  		xlabel='"time"'
  		ylabel='"size(KB)"'
		yrange='[0:10000]'

  		plot=( '"../../gnuInput/'$img'"'  using 1:\(\$8/1000\) title '"recv"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$9/1000\) title '"send"' with points pointtype 7 pointsize 0.5  )

  		graph
	}

# Plot disk usage
	plotdisk(){
  		fileType="png"
  		output='"disk.png"'
  		title='"Disk Usage"'
  		xlabel='"time"'
  		ylabel='"size(KB)"'
		yrange='[0:100000]'

  		plot=( '"../../gnuInput/'$img'"'  using 1:\(\$14/1000\) title '"read-sda2(db)"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$15/1000\) title '"write-sda2(db)"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$16/1000\) title '"read-sda3(archive)"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$17/1000\) title '"write-sda3(archive)"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$18/1000\) title '"read-sda5(xlog)"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$19/1000\) title '"write-sda5(xlog)"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$20/1000\) title '"read-total"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$21/1000\) title '"write-total"' with points pointtype 7 pointsize 0.5 )

  		graph
	}

# Plot load average
	plotload(){
  		fileType="png"
  		output='"cpu_load_average.png"'
  		title='"CPU Load Average"'
  		xlabel='"time"'
  		ylabel='"CPU Load Average"'
		yrange='[0:500]'
  		plot=( '"../../gnuInput/'$img'"'  using 1:22 title '"1m"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:23 title '"5m"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:24 title '"15m"' with points pointtype 7 pointsize 0.5  )

  	graph
	}

# Plot swap usage
	plotswap(){
  		fileType="png"
  		output='"swap.png"'
  		title='"Swap Usage"'
  		xlabel='"time"'
  		ylabel='"size(MB)"'
		yrange='[0:100]'
  		plot=( '"../../gnuInput/'$img'"'  using 1:\(\$25/1000000\) title '"used"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$26/1000000\) title '"free"' with points pointtype 7 pointsize 0.5  )

  		graph
	}

	plotdiskutil(){
                fileType="png"
                output='"disk-util.png"'
                title='"Disk Utilization"'
                xlabel='"time"'
                ylabel='"percent"'
  		yrange='[0:100]'
		plot=( '"../../gnuInput/'$img'"'  using 1:27 title '"util-sda2(db)"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:28 title '"util-sda3(archive)"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:29 title '"util-sda5(xlog)"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"' using 1:30 title '"util-total"' with points pointtype 7 pointsize 0.5  )

                graph
        }


	setdir
# Plot results
	echo "Plot results into '$directory' directory"
	plotmem
	plotnet
	plotcpu
	plotdisk
	plotload
	plotswap
	plotdiskutil
	cd /home/sachin/jdbcrunner-1.2/
	#cd /usr/local/jdbcrunner-1.2/jdbcrunner-1.2/
	
	done 



#-------------Printing  Driver Machine Dstat----------------------

	for file in ./benchmark/$date/*/*/gnuInput/stat_local.dat
	do
		server=$(echo "$file" | cut -c 33-39)
		run=$(echo "$file" | cut -c 41-44)
		img=$(echo "$file" | cut -c 55-68)


# Make directory to store the results
		setdir(){
			directory=$(echo "./benchmark/$date/$server/$run/gnuPlot/DriverMachineDstat")
			mkdir -p $directory
			cd $directory

		}


#############################################
# MAIN BLOCK
#############################################
# Use GNU plot to plot the graph
	graph () {
gnuplot << EOF
	set terminal $fileType size 840,480
	set size 1,1
	set lmargin at screen 0.10
	set rmargin at screen 0.70
	set key outside right top vertical Right noreverse enhanced autotitles box linetype -1 linewidth 1.000
	set output $output
	set title $title
	set xlabel $xlabel
	set ylabel $ylabel
	set yrange $yrange
	plot ${plot[*]}
EOF
	}

# Plot CPU usage
	plotcpu(){
 		fileType="png"
  		output='"cpu.png"'
  		title='"CPU Usage"'
  		xlabel='"time"'
  		ylabel='"percent"'
		yrange='[0:100]'

  		plot=( '"../../gnuInput/'$img'"'  using 1:2 title '"user"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:3 title '"system"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:4 title '"idle"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"' using 1:5 title '"iowait"' with points pointtype 7 pointsize 0.5  )

  		graph
	}

# Plot memory usage
	plotmem(){
  		fileType="png"
  		output='"memory.png"'
  		title='"Memory Usage"'
  		xlabel='"time"'
  		ylabel='"size(MB)"'
		yrange='[0:100]'

  		plot=( '"../../gnuInput/'$img'"'  using 1:\(\$10/1000000\) title '"used"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$11/1000000\) title '"buff"' with points pointtype 7 pointsize 0.5 , '"../../gnuInput/'$img'"'  using 1:\(\$12/1000000\) title '"cach"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$13/1000000\) title '"free"' with points pointtype 7 pointsize 0.5  )

  		graph
	}

# Plot network usage
	plotnet(){
  		fileType="png"
  		output='"network.png"'
  		title='"Network Usage"'
  		xlabel='"time"'
  		ylabel='"size(KB)"'
		yrange='[0:10000]'

  		plot=( '"../../gnuInput/'$img'"'  using 1:\(\$8/1000\) title '"recv"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$9/1000\) title '"send"' with points pointtype 7 pointsize 0.5  )

  		graph
	}

# Plot disk usage
	plotdisk(){
  		fileType="png"
  		output='"disk.png"'
  		title='"Disk Usage"'
  		xlabel='"time"'
  		ylabel='"size(KB)"'
		yrange='[0:100000]'

  	#	plot=( '"../../gnuInput/'$img'"'  using 1:\(\$14/1000\) title '"read-sda2(db)"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$15/1000\) title '"write-sda2(db)"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$16/1000\) title '"read-sda3(archive)"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$17/1000\) title '"write-sda3(archive)"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$18/1000\) title '"read-sda5(xlog)"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$19/1000\) title '"write-sda5(xlog)"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$20/1000\) title '"read-total"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$21/1000\) title '"write-total"' with points pointtype 7 pointsize 0.5 )
  		plot=( '"../../gnuInput/'$img'"'  using 1:\(\$20/1000\) title '"read-total"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$21/1000\) title '"write-total"' with points pointtype 7 pointsize 0.5 )
  		graph
	}

# Plot load average
	plotload(){
  		fileType="png"
  		output='"cpu_load_average.png"'
  		title='"CPU Load Average"'
  		xlabel='"time"'
  		ylabel='"CPU Load Average"'
		yrange='[0:500]'
  		plot=( '"../../gnuInput/'$img'"'  using 1:22 title '"1m"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:23 title '"5m"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:24 title '"15m"' with points pointtype 7 pointsize 0.5  )

  	graph
	}

# Plot swap usage
	plotswap(){
  		fileType="png"
  		output='"swap.png"'
  		title='"Swap Usage"'
  		xlabel='"time"'
  		ylabel='"size(MB)"'
		yrange='[0:100]'
  		plot=( '"../../gnuInput/'$img'"'  using 1:\(\$25/1000000\) title '"used"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:\(\$26/1000000\) title '"free"' with points pointtype 7 pointsize 0.5  )

  		graph
	}

	plotdiskutil(){
                fileType="png"
                output='"disk-util.png"'
                title='"Disk Utilization"'
                xlabel='"time"'
                ylabel='"percent"'
  		yrange='[0:100]'
	#	plot=( '"../../gnuInput/'$img'"'  using 1:27 title '"util-sda2(db)"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:28 title '"util-sda3(archive)"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"'  using 1:29 title '"util-sda5(xlog)"' with points pointtype 7 pointsize 0.5 ,'"../../gnuInput/'$img'"' using 1:30 title '"util-total"' with points pointtype 7 pointsize 0.5  )
		plot=( '"../../gnuInput/'$img'"' using 1:30 title '"util-total"' with points pointtype 7 pointsize 0.5  )

                graph
        }


	setdir
# Plot results
	echo "Plot results into '$directory' directory"
	plotmem
	plotnet
	plotcpu
	plotdisk
	plotload
	plotswap
	plotdiskutil
	cd /home/sachin/jdbcrunner-1.2/
	
	done 

	# Store postgresql.conf of the server
	ssh -n sachin@172.26.139.4 "scp /db/pgsql922-5432/postgresql.conf sachin@172.26.139.1:/home/sachin/jdbcrunner-1.2/benchmark/$date/"

done
