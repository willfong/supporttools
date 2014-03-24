cat > /etc/my.cnf.d/server.cnf << EOF
[mysqld]

# InnoDB Performance

innodb_buffer_pool_size=512MB
innodb_log_file_size=50MB
sync_binlog=0
innodb_flush_log_at_trx_commit=2
innodb_flush_method=O_DIRECT
skip-innodb_doublewrite
innodb_old_blocks_time=1000
innodb_purge_threads=1

# Replication

log-bin=mysqlbinlog
log-bin-index=mysqlbinlog.index
server-id=`cat /server_id.txt`
relay-log=mysqlrelay
relay-log-index=mysqlrelay.index

EOF

