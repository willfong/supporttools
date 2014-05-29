cat <<EOF > /etc/my.cnf.d/server.cnf
[mysqld]
log_error=/var/lib/mysql/mysql.err

innodb_buffer_pool_size=2G
innodb_log_file_size=1G
sync_binlog=0
innodb_flush_log_at_trx_commit=2
skip-innodb_doublewrite
innodb_old_blocks_time=1000
innodb_purge_threads=1
innodb_file_per_table=1
performance_schema=off
EOF
