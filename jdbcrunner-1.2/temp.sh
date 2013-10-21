startts='2013-03-14 00:00:00'
endts='2013-03-19 00:00:00'
snapids=`psql -h 172.26.137.4 -d postgres -c "copy (select min(snapid),max(snapid) from statsrepo.snapshot where time between '$startts'::timestamp and '$endts'::timestamp) to stdout with delimiter ' '"`
min=`echo $snapids | awk '{print $1}'`
max=`echo $snapids | awk '{print $2}'`
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
						to_char('$startts'::timestamp,'YYYY-MM-DD HH24:MI:SS')::timestamp and \
						to_char('$endts'::timestamp,'YYYY-MM-DD HH24:MI:SS')::timestamp \
					) \
					to stdout \
					with delimiter ' '"


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

