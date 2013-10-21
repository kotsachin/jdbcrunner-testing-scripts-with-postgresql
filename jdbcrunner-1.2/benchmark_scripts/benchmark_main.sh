#!/bin/bash -ex 

#----THIS PROGRAM IS WRAPPER ON TOP OF THE JDBCRUNNER TOOL USED FOR BENCHMARKING OF DIFFERNENT DATABASES LIKE POSTGRES,ORACLE,MYSQL ETC.----
#--IN THIS WRAPPER WE CAN SET THE CONFIGURABLE PARAMETSRS OF THE JDBCRUNNER AND RUN THE TEST OVER NIGHT.
#--Configure two way SSH login on each Server and Driver machine for user who is the owner of database like postgres.

#===========================================


(
(

#---Checking Shell variables are set or not---

if [ -z "$DRIVER_IP" ] || [ -z "$BKP_IP" ] || [ -z "$MASTER_IP" ] || [ -z "$MASTER_PORT" ] || [ -z "$MASTER_IP_LOAD" ] || [ -z "$MASTER_IP_REPLICATION" ] || [ -z "$MASTER_IP_TEST" ] || [ -z "$STANDBY_1_IP" ] || [ -z "$STANDBY_1_PORT" ] || [ -z "$STANDBY_2_IP" ] || [ -z "$STANDBY_2_PORT" ] || [ -z "$USER_NAME" ] || [ -z "$BENCH_DIR" ] || [ -z "$PGDATA" ] || [ -z "$PGPATH" ] || [ -z "$PG_CONF_FILES" ] || [ -z "$BKP_DIR" ] || [ -z "$PGLOG" ] || [ -z "$PGARC" ] || [ -z "$PGXLOG" ]
then
	"Shell variables not set" > error.log
	exit 1
fi



exec<benchmark.conf
while read nr wt mt na scl st1 st2 st3 st4 st5 bkp_from bkp_to tt        #reading parameters from benchmark.conf file
do
	
count=1
        [ "$nr" == "NR" ] && continue                       # Skip the Header
	
	mkdir -p benchmark
        date=$(date +"%Y-%m-%d-%H-%M-%S")
        mkdir -p ./benchmark/$date
	
	echo "   "
	echo "*********************************************************************************************"
	echo "Start time of benchmark: $date"
	echo "Number of runs: $nr" 
	echo "Warmup Time: $wt " 
	echo "Measurement Time: $mt" 
	echo "Number of Agents: $na" 
	echo "Scale: $scl"
	echo "Sleep Times: $st1, $st2, $st3, $st4, $st5"
	echo "Test type: $tt"
	echo "Backup from : $bkp_from"  
	echo "Backup to : $bkp_to"  
	echo "********************************************************************************************"
	echo "  "

	echo "Start time of benchmark: $date" > ./benchmark/$date/run_conf.txt
	echo "Number of runs: $nr" >> ./benchmark/$date/run_conf.txt
	echo "Warmup Time: $wt " >>  ./benchmark/$date/run_conf.txt
	echo "Measurement Time: $mt" >> ./benchmark/$date/run_conf.txt
	echo "Number of Agents: $na" >> ./benchmark/$date/run_conf.txt
	echo "Scale: $scl" >> ./benchmark/$date/run_conf.txt
	echo "Sleep Times: $st1, $st2, $st3, $st4, $st5" >> ./benchmark/$date/run_conf.txt
	echo "Test type: $tt" >> ./benchmark/$date/run_conf.txt
	echo "Backup from: $bkp_from" >> ./benchmark/$date/run_conf.txt
	echo "Backup to: $bkp_to" >> ./benchmark/$date/run_conf.txt

	

#-----START OF BENCHMARKING PHASE OF DATABASE-------

	while [ $nr -gt 0 ]
        do



#----SETTING SERVERS FOR DIFFERENT SCENARIOS------


	echo "*********************** Setting up servers for the test ************************************"
	if [ "$tt" == "SR" ] || [ "$tt" == "ncSR" ] || [ "$tt" == "cSR" ] ||  [ "$tt" == "Master-only" ]
        then

		sh setup_db.sh $tt 2> error.log
	else
		echo "Enter correct Test Type(tt) paramater value(SR/ncSR/cSR/Master_only)" > error.log
		exit 1
	fi

	echo "*********************** Servers set up for the test ****************************************"
	echo "  "

#----START OF LOADING PHASE OF BENCHMARK-----------

	#-------Starting Servers---------
	if [ "$tt" == "SR" ] || [ "$tt" == "ncSR" ] || [ "$tt" == "cSR" ]
        then
		echo "********************************************************************************************"

                if [ "$tt" == "ncSR" ] || [ "$tt" == "cSR" ]
                then

			
                        echo "Starting Standby-II DB server..."
                        sh start_standby.sh $STANDBY_2_IP 2> error.log
                        echo "Standby-II DB Server started."
			
                        sleep 10
                fi

		echo "Starting Standby-I DB server..."
		sh start_standby.sh $STANDBY_1_IP 2> error.log
		echo "Standby-I DB Server started."
		sleep 10
	fi

		echo "Starting Master DB server..."
		sh start_master.sh $MASTER_IP 2> error.log
		echo "Master DB Server started."
		
		echo "********************************************************************************************"
		echo " "
		sleep 10
		
	#-------Loading Dataset into Database------

		echo "********************************************************************************************"
		echo "Loading benchmark data with scale : $scl"
		java JR ../scripts/tpcc_load.js -jdbcUrl "jdbc:postgresql://$MASTER_IP:$MASTER_PORT/tpcc" -param0 $scl 1>/dev/null 2> error.log

	#----------Stopping Servers--------------                       
		echo "Stopping Master DB server..."
                sh stop_servers.sh $MASTER_IP 2> error.log
		echo "Master DB Server stopped."
	
	if [ "$tt" == "SR" ] || [ "$tt" == "ncSR" ] || [ "$tt" == "cSR" ]
        then
		echo "Stopping Standby-I DB server..."
		sh stop_servers.sh $STANDBY_1_IP 2> error.log
		echo "Standby-I DB Server stopped."

		if [ "$tt" == "ncSR" ] || [ "$tt" == "cSR" ]
                then

                        echo "Stopping Standby-II DB server..."
                        sh stop_servers.sh $STANDBY_2_IP 2> error.log
                        echo "Standby-II DB Server stopped."
                fi

		
	fi
	echo "********************************************************************************************"
	echo " "

#-----END OF LOADING PHASE---------



	echo "********************************************************************************************"
	#-------Starting Servers-----------------
	#-------Creating directory structure according to Test Type-------

	if [ "$tt" == "SR" ] || [ "$tt" == "ncSR" ] || [ "$tt" == "cSR" ]
        then
	
		if [ "$tt" == "ncSR" ] || [ "$tt" == "cSR" ]
	        then

			echo "Starting Standby-II DB server..."
	                sh start_standby.sh $STANDBY_2_IP 2> error.log
        	        echo "Standby-II DB Server started."
                	sleep 10
			mkdir -p ./benchmark/$date/Standby-2
			mkdir -p ./benchmark/$date/Standby-2/run$count/dstatOutput
			mkdir -p ./benchmark/$date/Standby-2/run$count/gnuInput
		fi

		echo "Starting Standby-I DB server..."
                sh start_standby.sh $STANDBY_1_IP 2> error.log
                echo "Standby-I DB Server started."
		sleep 10
        	mkdir -p ./benchmark/$date/Standby-1
		mkdir -p ./benchmark/$date/Standby-1/run$count/dstatOutput
		mkdir -p ./benchmark/$date/Standby-1/run$count/gnuInput
	fi

                echo "Starting Master DB server..."
                sh start_master.sh $MASTER_IP 2> error.log
                echo "Master DB Server started."
		sleep 10
        	mkdir -p ./benchmark/$date/Master
		mkdir -p ./benchmark/$date/Master/run$count/dstatOutput
		mkdir -p ./benchmark/$date/Master/run$count/jdbcRunnerLogs
		mkdir -p ./benchmark/$date/Master/run$count/pgStatsInfo
		mkdir -p ./benchmark/$date/Master/run$count/gnuInput

		tdate=$(date +"%Y-%m-%d-%H-%M-%S")
		dcount=$((wt+mt+10)) #---calculating count for dstat --

	#-------Removing old dstat csv files--
		ssh -n $USER_NAME@$MASTER_IP 'rm -f dstat.csv' 2> error.log
		echo "Removed old dstat file from Master Server"
		rm -f dstat_driver.csv 2> error.log
		echo "Removed old dstat file from Driver Machine"

	#----execute dstat utitity in background on the DB servers and clean old dsta files-------
		ssh -n $USER_NAME@$MASTER_IP "dstat -D sda2,sda3,sda5,sda9,sda -N eth1,eth2,eth3,eth4,eth5,total -tcnmdls --disk-util --output dstat.csv 1 $dcount 1>/dev/null" &
		echo "Executed dstat utility on Master Server"

		if [ "$tt" == "SR" ] || [ "$tt" == "ncSR" ] || [ "$tt" == "cSR" ]
	        then
			ssh -n $USER_NAME@$STANDBY_1_IP 'rm -f dstat.csv' 2> error.log
			echo "Removed old dstat file from Standby-1 Server"
                	ssh -n $USER_NAME@$STANDBY_1_IP "dstat -D sda2,sda3,sda5,sda9,sda -N eth1,eth2,eth3,eth4,eth5,total -tcnmdls --disk-util --output dstat.csv 1 $dcount 1>/dev/null" &
			echo "Executed dstat utility on Standby-1 Server"

                	if [ "$tt" == "ncSR" ] || [ "$tt" == "cSR" ]
                	then
				ssh -n $USER_NAME@$STANDBY_2_IP 'rm -f dstat.csv' 2> error.log
				echo "Removed old dstat file from Standby-2 Server" 
                		ssh -n $USER_NAME@$STANDBY_2_IP "dstat -D sda2,sda3,sda5,sda9,sda -N eth1,eth2,eth3,eth4,eth5,total -tcnmdls --disk-util --output dstat.csv 1 $dcount 1>/dev/null" &
				echo "Executed dstat utility on Standby-2 Server"

                	fi
        	fi

	#----execute dstat utility in background on the driver/local (this) server------	
		dstat -N eth1,eth2,eth3,system_eth4,eth5,total -tcnmdls --disk-util --output dstat_driver.csv 1 $dcount 1>/dev/null &
		echo "Executed dstat utility on Driver Machine"
		echo "********************************************************************************************"
		echo "Running Benchmark on Master: run $count"
	

	#------command to run jdbcrunner benchmark test----
	        java JR $1 -warmupTime $wt -measurementTime $mt -nAgents $na -sleepTime $st1,$st2,$st3,$st4,$st5 -jdbcUrl "jdbc:postgresql://$MASTER_IP_TEST:$MASTER_PORT/tpcc" -logDir "./benchmark/$date/Master/run$count/jdbcRunnerLogs/" >./benchmark/$date/Master/run$count/jdbcRunnerLogs/$tdate.txt &    # Print values read in variable
		
	#--------Last backgroung process_id----
	
	jdbcrunner_pid=$!

	if [  "$bkp_from" == "master" ] || [  "$bkp_from" == "standby-1" ] || [  "$bkp_from" == "standby-2" ]
	then
		
	#-------Taking backups from Servers---------
		if [  "$bkp_to" == "master" ] || [  "$bkp_to" == "standby-1" ] || [  "$bkp_to" == "standby-2" ]
        	then
			sh backups.sh $date $count $bkp_from $wt 2> error.log #---Taking backup on same Server
		elif [  "$bkp_to" == "backup-server" ]
		then
			sh backups_on_backup-server.sh $date $count $bkp_from $wt 2> error.log	#----Taking backup on different Server	
		else
			echo "Please enter where you want to store backup(in benchmark.conf bkp_to parameter" > error.log
		fi
	fi
		wait $jdberunner_pid
	#------command to run jdbcrunner benchmark test----

	#-------------Retrieve the dstat report from the DB server--------------------------------
		ssh -n $USER_NAME@$MASTER_IP 'scp dstat.csv '$USER_NAME'@'$DRIVER_IP':'$BENCH_DIR' ' 2> error.log
		#ssh -n $USER_NAME@$MASTER_IP "scp dstat.csv $USER_NAME@$DRIVER_IP:$BENCH_DIR"
		mv dstat.csv ./benchmark/$date/Master/run$count/dstatOutput/dstat.csv 2> error.log
		mv dstat_driver.csv ./benchmark/$date/Master/run$count/dstatOutput/dstat_driver.csv 2> error.log

		if [ "$tt" == "SR" ] || [ "$tt" == "ncSR" ] || [ "$tt" == "cSR" ]
	        then
			ssh -n $USER_NAME@$STANDBY_1_IP 'scp dstat.csv '$USER_NAME'@'$DRIVER_IP':'$BENCH_DIR' ' 2> error.log
                	mv dstat.csv ./benchmark/$date/Standby-1/run$count/dstatOutput/dstat.csv 2> error.log

	                if [ "$tt" == "ncSR" ] || [ "$tt" == "cSR" ]
        	        then
				ssh -n $USER_NAME@$STANDBY_2_IP 'scp dstat.csv '$USER_NAME'@'$DRIVER_IP':'$BENCH_DIR' ' 2> error.log
                		mv dstat.csv ./benchmark/$date/Standby-2/run$count/dstatOutput/dstat.csv 2> error.log
                	fi
        	fi


		

	#--------------Retrieve resultant stats from pg_statsinfo. ---------------------------------------------------
	#---It retrives data for the snapshots that were taken within the measurement interval of the benchmark-------
		
		sh pg_stats_info.sh $date $count 2> error.log

	#----------Stopping Servers--------------			
		echo "Stopping Master DB server..."
                sh stop_servers.sh $MASTER_IP 2> error.log
                echo "Master DB Server stopped."

	if [ "$tt" == "SR" ] || [ "$tt" == "ncSR" ] || [ "$tt" == "cSR" ]
        then
                echo "Stopping Standby-I DB server..."
                sh stop_servers.sh $STANDBY_1_IP 2> error.log
                echo "Standby-I DB Server stopped."

                if [ "$tt" == "ncSR" ] || [ "$tt" == "cSR" ]
                then

                        echo "Stopping Standby-II DB server..."
                        sh stop_servers.sh $STANDBY_2_IP 2> error.log
                        echo "Standby-II DB Server stopped."
                fi


        fi


#-----------END OF BENCHMARKING PHASE------

	 # Retrieve the PostgreSQL log
		fl=`ssh -n $USER_NAME@$MASTER_IP 'ls -lt  '$PGLOG'/*.csv | head -n 1' | awk '{print \$NF}'`
		log=$(echo "$fl" | cut -c 20-51)
		ssh -n $USER_NAME@$MASTER_IP "scp $fl $USER_NAME@$DRIVER_IP:$BENCH_DIR/benchmark/$date/Master/run$count/$log" 2> error.log
		if [ "$tt" == "SR" ] || [ "$tt" == "ncSR" ] || [ "$tt" == "cSR" ]
     	   	then
			fl=`ssh -n $USER_NAME@$STANDBY_1_IP 'ls -lt  '$PGLOG'/*.csv | head -n 1' | awk '{print \$NF}'`
			log=$(echo "$fl" | cut -c 20-51)
			ssh -n $USER_NAME@$STANDBY_1_IP "scp $fl $USER_NAME@$DRIVER_IP:$BENCH_DIR/benchmark/$date/Standby-1/run$count/$log" 2> error.log
               		if [ "$tt" == "ncSR" ] || [ "$tt" == "cSR" ]
                	then
				fl=`ssh -n $USER_NAME@$STANDBY_2_IP 'ls -lt  '$PGLOG'/*.csv | head -n 1' | awk '{print \$NF}'`
				log=$(echo "$fl" | cut -c 20-51)
				ssh -n $USER_NAME@$STANDBY_2_IP "scp $fl $USER_NAME@$DRIVER_IP:$BENCH_DIR/benchmark/$date/Standby-2/run$count/$log" 2> error.log
               		 fi
       		fi
	
	# Store postgresql.conf of the server
		ssh -n $USER_NAME@$MASTER_IP "scp $PGDATA/postgresql.conf $USER_NAME@$DRIVER_IP:$BENCH_DIR/benchmark/$date/Master/run$count/" 2> error.log
		if [ "$tt" == "SR" ] || [ "$tt" == "ncSR" ] || [ "$tt" == "cSR" ]
        	then
			ssh -n $USER_NAME@$STANDBY_1_IP "scp $PGDATA/postgresql.conf $USER_NAME@$DRIVER_IP:$BENCH_DIR/benchmark/$date/Standby-1/run$count/" 2> error.log

                	if [ "$tt" == "ncSR" ] || [ "$tt" == "cSR" ]
                	then
				ssh -n $USER_NAME@$STANDBY_2_IP "scp $PGDATA/postgresql.conf $USER_NAME@$DRIVER_IP:$BENCH_DIR/benchmark/$date/Standby-2/run$count/" 2> error.log
                	fi
        	fi

		
		nr=$((nr-1))
		count=$((count+1))
	echo "********************************************************************************************"
	echo " "

	done
#-----End of Number od run loop here ----------

#---Output processing and Graph printing-----------------

	echo "********************************************************************************************"
	echo "-----Plotting Results Graphs-------"
	sh jdbcrunner_plot_line.sh $date $st1 $st2 $st3 $st4 $st5 2> error.log
	sh dstat_plot.sh $date $mt 2> error.log
	sh pg_stats_info_plot.sh $date 2> error.log
	sh avg.sh $date 2> error.log
	sh avg_wal.sh $date 2> error.log
	sh backup_throughput.sh 2> error.log
	sh tps_avg.sh $date 2> error.log
	echo "********************************************************************************************"
	echo " "




done

) 2> error.log

) 2>&1 | tee performance_script.log
