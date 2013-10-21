dcount=20
echo $dcount
ssh  sachin@172.26.127.116 "dstat -D sda2,sda3,sda5,sda -tcnmdls --disk-util 1 $dcount "
