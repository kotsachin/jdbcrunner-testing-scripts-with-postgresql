#!/bin/bash
val='16:32:15'
for i in {1..60}
	do
		val=$(date -d $val' 1 sec' +%T)
		echo $val
	done
