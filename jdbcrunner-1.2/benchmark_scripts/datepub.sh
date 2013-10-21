
#---Be root before executing this script.
#--This script is used to syncronize time between all Server Machine.
#--Execute this script from driver machine before running benchmark test.

ts=`date`
echo $ts
ssh root@172.26.126.154 "date -s '$ts'"
ssh root@172.26.126.155 "date -s '$ts'"
ssh root@172.26.126.156 "date -s '$ts'"
