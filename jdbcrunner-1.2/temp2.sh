startts='2013-03-18 00:00:00'
                endts='2013-03-19 18:00:00'

		echo $startts, $endts
                snapids=`psql -h 172.26.139.4 -d postgres -c "copy( \
					select \
						min(snapid), \
						max(snapid) \
					from statsrepo.snapshot \
					where \
						to_char(time::timestamp, 'YYYY-MM-DD HH24:MI:SS')::timestamp between '$startts'::timestamp and '$endts'::timestamp
					) \
					to stdout \
					with delimiter ' '"`

                min=`echo $snapids | awk '{print $1}'`
                max=`echo $snapids | awk '{print $2}'`
                psql -h 172.26.139.4 -d postgres -c "copy( \
					select \
						to_char(time::timestamp,'HH:MI:SS')::timestamp, \
						x.* \
					from statsrepo.snapshot sn, statsrepo.database x \
					where \
						x.snapid between $min and $max and \
						x.snapid=sn.snapid and name='tpcc' \
					) \
					to stdout \
					with delimiter ' '" > ./benchmark/$date/Server1/Run$count/pg_stats_info/dbstats.csv

		psql -h 172.26.137.4 -d postgres -c "copy( \
                                        select \
                                                instid, \
                                                to_char(start::timestamp,'YYYY-MM-DD HH24:MI:SS')::timestamp, \
                                                flags, \
                                                num_buffers, \
                                                xlog_added, \
                                                xlog_removed, \
                                                xlog_recycled, \
                                                write_duration, \
                                                sync_duration, \
                                                total_duration \
                                        from statsrepo.checkpoint \
                                        where \
                                                to_char(start::timestamp,'YYYY-MM-DD HH24:MI:SS')::timestamp between \
                                                '$startts'::timestamp and \
                                                '$endts'::timestamp \
                                        ) \
                                        to stdout \
                                        with delimiter ' '"> ./benchmark/$date/Server1/Run$count/pg_stats_info/checkpoint.csv

		psql -h 172.26.137.4 -d postgres -c "copy( \
                                        select \
                                                av.instid, \
                                                to_char(av.start::timestamp,'YYYY-MM-DD HH24:MI:SS')::timestamp, \
                                                av.database, \
                                                av.schema, \
                                                av.table, \
                                                av.index_scans, \
                                                av.page_removed, \
                                                av.page_remain, \
                                                av.tup_removed, \
                                                av.tup_remain, \
                                                av.page_hit, \
                                                av.page_miss, \
                                                av.page_dirty, \
                                                av.read_rate, \
                                                av.write_rate, \
                                                av.duration \
                                        from statsrepo.autovacuum av \
                                        where \
                                                database='tpcc' and \
                                                to_char(start::timestamp,'YYYY-MM-DD HH24:MI:SS')::timestamp between \
                                                to_char('$startts'::timestamp,'YYYY-MM-DD HH24:MI:SS')::timestamp and \
                                                to_char('$endts'::timestamp,'YYYY-MM-DD HH24:MI:SS')::timestamp \
                                        ) \
                                        to stdout \
                                        with delimiter ' '"
