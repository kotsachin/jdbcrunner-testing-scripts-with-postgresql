#!/bin/bash -ex
#NOTE:put binary of pg_basebackup at PGPATH directory location to take backup on backup server.
#Also configure replication settings in pg_hba.conf for backup server ip address from each postgreSQL server(master,standby-1,standby-2). 

date=$1
count=$2
bkp=$3
wt=$4
(
#------Script to take backup from Master,Standby-I and Standby-II on different Server-----
	
			scount=$((wt+100))
                        sleep $scount

                        if [ "$bkp" == "master" ]
                        then
                                bkp_start=$(date +"%Y-%m-%d-%H-%M-%S")
                                echo "Backup from Master Start Time: $bkp_start" > ./benchmark/$date/Master/run$count/bkp_result.txt
                                ssh -n $USER_NAME@$BKP_IP "$PGPATH/pg_basebackup -h $MASTER_IP -p $MASTER_PORT -D $BKP_DIR/$date/backup-$count -l 'backup-$count'"
                                bkp_stop=$(date +"%Y-%m-%d-%H-%M-%S")
                                echo "Backup from Master Stop Time: $bkp_stop" >> ./benchmark/$date/Master/run$count/bkp_result.txt
				size=`ssh -n $USER_NAME@$BKP_IP 'du -h '$BKP_DIR'/'$date'/backup-'$count'/ | tail -n 1 ' | awk '{print $1}'`
				echo "Total backup size: $size " >> ./benchmark/$date/Master/run$count/bkp_result.txt
				ssh -n $USER_NAME@$BKP_IP "cat $BKP_DIR/'$date'/backup-'$count'/backup_label" > ./benchmark/$date/Master/run$count/backup_label.txt
			#	ssh -n $USER_NAME@$BKP_IP "rm -rf $BKP_DIR/*"
                        elif [ "$bkp" == "standby-1" ]
			then
                                bkp_start=$(date +"%Y-%m-%d-%H-%M-%S")
                                echo "Backup from Standby-I Start Time: $bkp_start" > ./benchmark/$date/Standby-1/run$count/bkp_result.txt
                                ssh -n $USER_NAME@$BKP_IP "$PGPATH/pg_basebackup -h $STANDBY_1_IP -p $STANDBY_1_PORT -D $BKP_DIR/$date/backup-$count -l 'backup-$count'"
                                bkp_stop=$(date +"%Y-%m-%d-%H-%M-%S")
                                echo "Backup from Standby-I Stop Time: $bkp_stop" >> ./benchmark/$date/Standby-1/run$count/bkp_result.txt
				size=`ssh -n $USER_NAME@$BKP_IP 'du -h '$BKP_DIR'/'$date'/backup-'$count'/ | tail -n 1 ' | awk '{print $1}'`
				echo "Total backup size: $size " >> ./benchmark/$date/Standby-1/run$count/bkp_result.txt
				ssh -n $USER_NAME@$BKP_IP "cat $BKP_DIR/'$date'/backup-'$count'/backup_label" > ./benchmark/$date/Standby-1/run$count/backup_label.txt

			#	ssh -n $USER_NAME@$BKP_IP "rm -rf $BKP_DIR/*"
			else 
                                bkp_start=$(date +"%Y-%m-%d-%H-%M-%S")
                                echo "Backup from Standby-II Start Time: $bkp_start" > ./benchmark/$date/Standby-2/run$count/bkp_result.txt
                                ssh -n $USER_NAME@$BKP_IP "$PGPATH/pg_basebackup -h $STANDBY_2_IP -p $STANDBY_2_PORT -D $BKP_DIR/$date/backup-$count -l 'backup-$count'"
                                bkp_stop=$(date +"%Y-%m-%d-%H-%M-%S")
                                echo "Backup from Standby-II Stop Time: $bkp_stop" >> ./benchmark/$date/Standby-2/run$count/bkp_result.txt
				size=`ssh -n $USER_NAME@$BKP_IP 'du -h '$BKP_DIR'/'$date'/backup-'$count'/ | tail -n 1 ' | awk '{print $1}'`
				echo "Total backup size: $size " >> ./benchmark/$date/Standby-2/run$count/bkp_result.txt
				ssh -n $USER_NAME@$BKP_IP "cat $BKP_DIR/'$date'/backup-'$count'/backup_label" >  ./benchmark/$date/Standby-2/run$count/backup_label.txt
			#	ssh -n $USER_NAME@$BKP_IP "rm -rf $BKP_DIR/*"
                        fi
) 2> error.log
