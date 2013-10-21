#!/bin/bash -ex

date=$1
for file in ./benchmark/$date/*/*/gnuInput/stat.dat
        do
		path=`dirname $file`
                f=${path%/*}

 awk \
'{usr+=$2; sys+=$3; idle+=$4; iowait+=$5; hiq+=$6; siq+=$7;recv+=($18/1048576);send+=($19/1048576);used+=($20/1048576); buff+=($21/1048576); cach+=($22/1048576);free+=($23/1048576); \
read+=($32/1048576); writ+=($33/1048576);m1+=$34; m5+=$35; m15+=$36;sused+=($37/1048576);sfree+=($38/1048576);util+=$43;  } \
END { print "========CPU usage:-============\n usr: "usr/NR "\n","sys: "sys/NR "\n","idle: "idle/NR "\n","wait: "iowait/NR "\n","hiq: "hiq/NR "\n","siq: "siq/NR "\n", \
"================Network usage:============= \n receive: "recv/NR "\n","send :"send/NR "\n", \
"============Memory usage:-=========== \n used: "used/NR "\n","buffeded: "buff/NR "\n","cached: "cach/NR "\n","free: "free/NR"\n", \
"===============Disk usage:-============= \n read: "read/NR"\n", "write: "writ/NR"\n" , \
"=================Load average:-============ \n For last 1 minute: " m1/NR "\n" ,"For last 5 minutes: " m5/NR "\n","For last 15 minutes: " m15/NR"\n", \
"=============Swap usage:-=========== \n used: "sused/NR "\n","free: " sfree/NR"\n", \
"=============Disk utilization:-========== \n util: " util/NR }'  $file  > $f/dstat_avg_result.txt 2> error.log

done


for file in ./benchmark/$date/*/*/gnuInput/stat_driver.dat
        do
		path=`dirname $file`
                f=${path%/*}

 awk \
'{usr+=$2; sys+=$3; idle+=$4; iowait+=$5; hiq+=$6; siq+=$7;recv+=($18/1048576);send+=($19/1048576);used+=($20/1048576); buff+=($21/1048576); cach+=($22/1048576);free+=($23/1048576); \
read+=($24/1048576); writ+=($25/1048576);m1+=$26; m5+=$27; m15+=$28;sused+=($29/1048576);sfree+=($30/1048576);util+=$31;  } \
END { print "========CPU usage:-============\n usr: "usr/NR "\n","sys: "sys/NR "\n","idle: "idle/NR "\n","wait: "iowait/NR "\n","hiq: "hiq/NR "\n","siq: "siq/NR "\n", \
"================Network usage:============= \n receive: "recv/NR "\n","send :"send/NR "\n", \
"============Memory usage:-=========== \n used: "used/NR "\n","buffeded: "buff/NR "\n","cached: "cach/NR "\n","free: "free/NR"\n", \
"===============Disk usage:-============= \n read: "read/NR"\n", "write: "writ/NR"\n" , \
"=================Load average:-============ \n For last 1 minute: " m1/NR "\n" ,"For last 5 minutes: " m5/NR "\n","For last 15 minutes: " m15/NR"\n", \
"=============Swap usage:-=========== \n used: "sused/NR "\n","free: " sfree/NR"\n", \
"=============Disk utilization:-========== \n util: " util/NR }'  $file  > $f/dstat_driver__avg_result.txt 2> error.log

done


