#!bin/bash
date=$(date) 
cdate=$(echo "$date" | cut -c 5-19)
echo "$cdate" 
ssh root@172.26.126.156 'date -s "$cdate"'

