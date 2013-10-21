#!/bin/bash


awk 'BEGIN{ORS="";}{i=2; while(i<=NF) {print substr($i,1,8),"\t";i++;} print "\n";} ' | \
                        awk -v str=$ts '{if($1>=str) print $0}' | \
                        awk -v val=1 -v mtcnt=$mt 'BEGIN{ORS="";} \
                        {if(val<=mtcnt) {i=2; print val," "; while(i<=NF) {print $i," "; i=i+1; } print "\n";} val=val+1}' \
                        >  ./benchmark/$date/$server/$run/gnuInput/stat.dat

