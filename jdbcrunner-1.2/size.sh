#!/bin/bash


date=$1
count=1
size=`ssh -n sachin@172.26.139.4 'du -h /home/sachin/backups/test_backups/'$date'/backup-'$count'/ | tail -n 1 ' | awk '{print $1}'`
#echo "Total backup size: $size " >> ./benchmark/$date/Server1/Run$count/BKP_RESULT.txt
ssh -n sachin@172.26.139.4 "scp /home/sachin/backups/test_backups/'$date'/backup-'$count'/backup_label sachin@172.26.139.1:/home/sachin/jdbcrunner-1.2/benchmark/$date/Server1/Run$count/backup_label.txt"

