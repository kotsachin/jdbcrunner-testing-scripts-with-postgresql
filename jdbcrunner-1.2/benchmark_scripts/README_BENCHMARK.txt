
==============README file for doing benchmark test using jdbcrunner-1.2===============

-------Setting envirinment variables to configure jdbcrunner---

example:export CLASSPATH=/usr/share/java/xalan-j2.jar:/home/sachin/jdbcrunner-1.2/jdbcrunner-1.2.jar

--export the path of xalan-j2.jar and jdbcrunner-1.2.jar files to work jdbcrunner properly.


-- set environment variables in main.sh


-----benchmark.conf configuration parameters--------(all parameters are compulsary)------

NR -Number of repeatations/Runs      
WT -WarmupTime jdbcrunner configuration parameter      
MT -MeasurementTime jdbcrunner configuration parameter     
NA -Number of Agents/Clients     
SCL -Scale     
ST1 -SleepTime for Transaction-Type-1    
ST2 -SleepTime for Transaction-Type-2    
ST3 -SleepTime for Transaction-Type-3    
ST4 -SleepTime for Transaction-Type-4    
ST5 -SleepTime for Transaction-Type-5    

BKP_FROM - Backup from which server(values:- master,standby-1,standby2,off)   
BKP_TO - Backup to which server(values:-master,standby-1,standby2,off,backup-server)   
TT  Test Type (values:- Master-Only,SR,ncSR,cSR)

----To know more about this parameters read documentation of jdbcrunner-1.2---@---
http://hp.vector.co.jp/authors/VA052413/jdbcrunner/manual_ja/
https://github.com/sh2/jdbcrunner


-------Configure passwordless ssh----------------------

# ssh-keygen -t rsa
#scp / USER_NAME /.ssh/id_rsa.pub
USER_NAME@SERVERTO:/USER_NAME/.ssh/authorized_keys2

If you already have an authorized_keys2 file on SERVERTO, then just append the
new key to the end of it by copying the key to SERVERTO and then appending it
like:
#scp /USER_NAME/.ssh/id_rsa.pub USER_NAME@serverto:/USER_NAME/.ssh/id_rsa.pub
Then on the SERVERTO server, just concatenate the file id_rsa.pub to the
authorized_keys2 file like:

#cd /USER_NAME/.ssh
#cat id_rsa.pub >> authorized_keys2

For transfer of files from one server to other we need to configure scp from
all servers to driver machine and driver machine to all others servers. Also
configure scp between each server.Also from backup server.



-------How to run benchmark script---------------------

sh main.sh

--main.sh -- This is the main benchmark script file to execute benchmark tests.In this file we need to set 
correct value for each variable as per our environment setup.





