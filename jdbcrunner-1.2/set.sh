 ssh  sachin@172.26.127.116 <<EOF
        cat /db/pgsql922-5432/postgresql.conf | awk '{if(\$1=="checkpoint_segments")  print \$1,\$2,"900",\$4,\$5; else print \$0}' > temp.conf
	cat temp.conf | awk '{if(\$1=="checkpoint_segments") print $3}'
        mv temp.conf /db/pgsql922-5432/postgresql.conf
        cat /db/pgsql922-5432/postgresql.conf | awk '{if(\$1=="archive_mode")  print \$1,\$2,"off",\$4,\$5; else print \$0}' > temp.conf
        mv temp.conf /db/pgsql922-5432/postgresql.conf
        rm -f temp.conf
EOF

