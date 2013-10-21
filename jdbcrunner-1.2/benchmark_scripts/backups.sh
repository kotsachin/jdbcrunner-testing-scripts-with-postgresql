#!/bin/bash -ex


date=$1
count=$2
bkp=$3
wt=$4

(

#------Script to take backup from Master,Standby-I and Standby-II on same Server-----

			
			scount=$((wt+100))
                        sleep $scount

                        if [ "$bkp" == "master" ]
                        then
                                bkp_start=$(date +"%Y-%m-%d-%H-%M-%S")
                                echo "Backup from $bkp Start Time: $bkp_start" > ./benchmark/$date/Master/run$count/bkp_result.txt
                                ssh -n $USER_NAME@$MASTER_IP "$PGPATH/pg_basebackup -D $BKP_DIR/$date/backup-$count -l 'backup-$count'"
                                bkp_stop=$(date +"%Y-%m-%d-%H-%M-%S")
                                echo "Backup from $bkp Stop Time: $bkp_stop" >> ./benchmark/$date/Master/run$count/bkp_result.txt
				size=`ssh -n $USER_NAME@$MASTER_IP 'du -h '$BKP_DIR'/'$date'/backup-'$count'/ | tail -n 1 ' | awk '{print $1}'`
				echo "Total backup size: $size " >> ./benchmark/$date/Master/run$count/bkp_result.txt
				ssh -n $USER_NAME@$MASTER_IP "scp $BKP_DIR/'$date'/backup-'$count'/backup_label $USER_NAME@$DRIVER_IP:$BENCH_DIR/benchmark/$date/Master/run$count/backup_label.txt"

                        elif [ "$bkp" == "standby-1" ]
			then
                                bkp_start=$(date +"%Y-%m-%d-%H-%M-%S")
                                echo "Backup from $bkp Start Time: $bkp_start" > ./benchmark/$date/Standby-1/run$count/bkp_result.txt
                                ssh -n $USER_NAME@$STANDBY_1_IP "$PGPATH/pg_basebackup -D $BKP_DIR/$date/backup-$count -l 'backup-$count'"
                                bkp_stop=$(date +"%Y-%m-%d-%H-%M-%S")
                                echo "Backup from $bkp Stop Time: $bkp_stop" >> ./benchmark/$date/Standby-1/run$count/bkp_result.txt
				size=`ssh -n $USER_NAME@$STANDBY_1_IP 'du -h '$BKP_DIR'/'$date'/backup-'$count'/ | tail -n 1 ' | awk '{print $1}'`
				echo "Total backup size: $size " >> ./benchmark/$date/Standby-1/run$count/bkp_result.txt
				ssh -n $USER_NAME@$STANDBY_1_IP "scp $BKP_DIR/'$date'/backup-'$count'/backup_label $USER_NAME@$DRIVER_IP:$BENCH_DIR/benchmark/$date/Standby-1/run$count/backup_label.txt"

			else 
                                bkp_start=$(date +"%Y-%m-%d-%H-%M-%S")
                                echo "Backup from $bkp Start Time: $bkp_start" > ./benchmark/$date/Standby-2/run$count/bkp_result.txt
                                ssh -n $USER_NAME@$STANDBY_2_IP "$PGPATH/pg_basebackup -p $STANDBY_2_PORT -D $BKP_DIR/$date/backup-$count -l 'backup-$count'"
                                bkp_stop=$(date +"%Y-%m-%d-%H-%M-%S")
                                echo "Backup from $bkp Stop Time: $bkp_stop" >> ./benchmark/$date/Standby-2/run$count/bkp_result.txt
				size=`ssh -n $USER_NAME@$STANDBY_2_IP 'du -h '$BKP_DIR'/'$date'/backup-'$count'/ | tail -n 1 ' | awk '{print $1}'`
				echo "Total backup size: $size " >> ./benchmark/$date/Standby-2/run$count/bkp_result.txt
				ssh -n $USER_NAME@$STANDBY_2_IP "scp $BKP_DIR/'$date'/backup-'$count'/backup_label $USER_NAME@$DRIVER_IP:$BENCH_DIR/benchmark/$date/Standby-2/run$count/backup_label.txt"
                        fi
) 2> error.log
