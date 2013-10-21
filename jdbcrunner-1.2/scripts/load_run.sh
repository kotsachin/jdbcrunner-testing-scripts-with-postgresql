#!/bin/bash

java JR tpcc.js -warmupTime 10 -measurementTime 60 -nAgents 4

#for i in {1..5}
#do 
#java JR tpcc.js -warmupTime 100 -measurementTime 600 -nAgents 10
#done

#for i in {1..5}
#do 
#java JR tpcc.js -warmupTime 100 -measurementTime 600 -nAgents 50
#done

#for i in {1..5}
#do 
#java JR tpcc.js -warmupTime 100 -measurementTime 600 -nAgents 100
#done





