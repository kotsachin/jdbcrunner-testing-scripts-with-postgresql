#!/bin/bash

for file in ./benchmark/2013-03-19-19-25-17/*/*/pg_stats_info/dbstats.csv
        do
        date=$(echo "$file" | cut -c 13-31)
        server=$(echo "$file" | cut -c 33-39)
        run=$(echo "$file" | cut -c 41-44)
        img=$(echo "$file" | cut -c 55-71)

        mkdir -p ./benchmark/$date/$server/$run/gnuPlot/pg_Stats

           graph () {
gnuplot << EOF
        set size 1,1
        set terminal $fileType size 840,480
        set output $output
        set key outside right top vertical Right noreverse enhanced autotitles box linetype -1 linewidth 1.000
        set title $title
        set xlabel $xlabel offset 38,1
        set ylabel $ylabel 
        set xdata time
        set timefmt "%H:%M:%S "
        set format x "%H:%M:%S"
        set xtics rotate autofreq
        set lmargin at screen 0.10
        set rmargin at screen 0.70
	set bmarg 4.40
        set yrange $yrange
        plot ${plot[*]}
EOF
        }
        plotdb1(){
                fileType="png"
                output='"DB_size.png"'
                title='"pg_Stats with DB_size"'
                xlabel='"Snap Taken Time \(HH:MM:SS)"'


                xlabel='"Snap Taken Time \(HH:MM:SS)"'
                ylabel='"Size of Database (in MB)"'
                yrange='[0:20000]'
                plot=( '"'$file'"'  using 2:\(\$6/1000000\) title '"pg_Stats with DB_size"' with lines  )
                graph
        }
        plotdb1
        mv DB_size.png ./benchmark/$date/$server/$run/gnuPlot/pg_Stats/DB_size.png

        plotdb2(){
                fileType="png"
                output='"DB_xact_commit.png"'
                title='"pg_Stats with DB_xact_commit"'
                xlabel='"Snap Taken Time \(HH:MM:SS)"'
                ylabel='"Number of xact_commit(in lakhs)"'
                yrange='[0:800]'
                plot=( '"'$file'"'  using 2:\(\$8/100000\) title '"pg_Stats with DB_xact_commit"' with lines  )
                graph
        }
        plotdb2
        mv DB_xact_commit.png ./benchmark/$date/$server/$run/gnuPlot/pg_Stats/DB_xact_commit.png

        plotdb3(){
                fileType="png"
                output='"DB_xact_rollback.png"'
                title='"pg_Stats with DB_xact_rollback"'
                xlabel='"Snap Taken Time \(HH:MM:SS)"'
                ylabel='"Number of xact_rollback (in Thousand)"'
                yrange='[0:500]'
                plot=( '"'$file'"'  using 2:\(\$9/1000\) title '"pg_Stats with DB_size"' with lines  )
                graph
        }
        plotdb3
                                                                                     
	mv DB_xact_rollback.png ./benchmark/$date/$server/$run/gnuPlot/pg_Stats/DB_xact_rollback.png

        plotdb4(){
                fileType="png"
                output='"DB_blks_read.png"'
                title='"pg_Stats with DB_blks_read"'
                xlabel='"Snap Taken Time \(HH:MM:SS)"'
                ylabel='"Number of bulks_read (in Millions)"'
                yrange='[0:1000]'
                plot=( '"'$file'"'  using 2:\(\$10/1000000\) title '"pg_Stats with DB_blks_read"' with lines  )
                graph
        }
        plotdb4
                                                                                     
	mv DB_blks_read.png ./benchmark/$date/$server/$run/gnuPlot/pg_Stats/DB_blks_read.png
        plotdb5(){
                fileType="png"
                output='"DB_bulks_hit.png"'
                title='"pg_Stats with DB_bulks_hit"'
                xlabel='"Snap Taken Time \(HH:MM:SS)"'
                ylabel='"Number of bulks_hit (in Billions)"'
                yrange='[0:50]'
                plot=( '"'$file'"'  using 2:\(\$11/1000000000\) title '"pg_Stats with DB_bulks_hit"' with lines  )
                graph
        }
        plotdb5
                                                                                     
	mv DB_bulks_hit.png ./benchmark/$date/$server/$run/gnuPlot/pg_Stats/DB_bulks_hit.png
        plotdb6(){
                fileType="png"
                output='"DB_tup_returned.png"'
                title='"pg_Stats with DB_tup_returned"'
                xlabel='"Snap Taken Time \(HH:MM:SS)"'
                ylabel='"Number of tup_returned (in Billions)"'
                yrange='[0:100]'
                plot=( '"'$file'"'  using 2:\(\$12/1000000000\) title '"pg_Stats with DB_tup_returned"' with lines  )
                graph
        }
        plotdb6
	mv DB_tup_returned.png ./benchmark/$date/$server/$run/gnuPlot/pg_Stats/DB_tup_returned.png
                                                                                     
        plotdb7(){
                fileType="png"
                output='"DB_tup_fetched.png"'
                title='"pg_Stats with DB_tup_fetched"'
                xlabel='"Snap Taken Time \(HH:MM:SS)"'
                ylabel='"Number of tup_fetched (in Billions)"'
                yrange='[0:100]'
                plot=( '"'$file'"'  using 2:\(\$13/1000000000\) title '"pg_Stats with DB_tup_fetched"' with lines  )
                graph
        }
        plotdb7
                                                                                     
	mv DB_tup_fetched.png ./benchmark/$date/$server/$run/gnuPlot/pg_Stats/DB_tup_fetched.png

        plotdb8(){
                fileType="png"
                output='"DB_tup_inserted.png"'
                title='"pg_Stats with DB_tup_inserted"'
                xlabel='"Snap Taken Time \(HH:MM:SS)"'
                ylabel='"Number of tup_inserted (in Millions)"'
                yrange='[0:1000]'
                plot=( '"'$file'"'  using 2:\(\$14/1000000\) title '"pg_Stats with DB_tup_inserted"' with lines  )
                graph
        }
        plotdb8
                                                                                     
	mv DB_tup_inserted.png ./benchmark/$date/$server/$run/gnuPlot/pg_Stats/DB_tup_inserted.png

        plotdb9(){
                fileType="png"
                output='"DB_tup_updated.png"'
                title='"pg_Stats with DB_tup_updated"'
                xlabel='"Snap Taken Time \(HH:MM:SS)"'
                ylabel='"Number of tup_updated (in Millions)"'
                yrange='[0:1000]'
                plot=( '"'$file'"'  using 2:\(\$15/1000000\) title '"pg_Stats with DB_tup_updated"' with lines  )
                graph
        }
        plotdb9
                                                                                     
	mv DB_tup_updated.png ./benchmark/$date/$server/$run/gnuPlot/pg_Stats/DB_tup_updated.png

        plotdb10(){
                fileType="png"
                output='"DB_tup_deleted.png"'
                title='"pg_Stats with DB_tup_deleted"'
                xlabel='"Snap Taken Time \(HH:MM:SS)"'
                ylabel='"Number of tup_deleted (in Millions)"'
                yrange='[0:50]'
                plot=( '"'$file'"'  using 2:\(\$16/1000000\) title '"pg_Stats with DB_tup_deleted"' with lines  )
                graph
        }
        plotdb10
                                                                                     
	mv DB_tup_deleted.png ./benchmark/$date/$server/$run/gnuPlot/pg_Stats/DB_tup_deleted.png



        done
 
