#!/usr/bin/gnuplot




set xdata time
set timefmt "%d-%m %H:%M:%S"
set format x "%H:%M"

set yrange [0:100]

set grid
set terminal png
set output "test.png"
set title "dstat CPU Usage"
set xlabel "time"
set ylabel "total-cpu-usage"

#-----time----- ----total-cpu-usage----
# date/time |usr sys idl wai hiq siq
#13-06 01:18:14| 5 1 93 1 0 0

plot "dstat.raw" using 1:3 w lp t "user [%]", \
"" u 1:4 w lp t "system [%]", \
"" u 1:5 w lp t "idle [%]", \
"" u 1:6 w lp t "wait [%]"


