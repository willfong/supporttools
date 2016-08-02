URL=http://downloads.mariadb.com/files/MariaDB/mariadb-10.1.14/bintar-linux-x86_64/mariadb-10.1.14-linux-x86_64.tar.gz

yum -y install libaio
rpm -Uvh http://downloads.mariadb.com/files/MariaDB/mariadb-10.1.14/yum/centos6-amd64/rpms/jemalloc-3.6.0-1.el6.x86_64.rpm
groupadd mysql
useradd -r -g mysql mysql
cd /usr/local
rm -rf mysql*
rm -rf maria*
wget $URL
tar xvzf m*.tar.gz
ls -d m*/ | xargs -I dirname ln -s dirname mysql
cd mysql
chown -R mysql .
chgrp -R mysql .
rm -rf /var/lib/mysql
mkdir /node1
mkdir /node2
mkdir /node3
scripts/mysql_install_db --user=mysql --datadir=/node1
scripts/mysql_install_db --user=mysql --datadir=/node2
scripts/mysql_install_db --user=mysql --datadir=/node3

chown -R root .
chown -R mysql /node1
chown -R mysql /node2
chown -R mysql /node3

cat <<EOF > /node1/my.cnf
[mysql]
socket=/node1/sock

[mysqld]
user=mysql
log_error=/node1/mysql.err
datadir=/node1
pid_file=/node1/mysql.pid
socket=/node1/sock
port=3307

innodb_buffer_pool_size=256M
innodb_log_file_size=256M
sync_binlog=0
innodb_flush_log_at_trx_commit=2
skip-innodb_doublewrite
innodb_old_blocks_time=1000
innodb_purge_threads=1
innodb_file_per_table=1
performance_schema=off

server-id=1

log-bin=binlog
log-bin-index=binlog.index

#plugin_load="rpl_semi_sync_master=semisync_master.so;rpl_semi_sync_slave=semisync_slave.so"
#rpl_semi_sync_master_enabled = ON
#rpl_semi_sync_slave_enabled = ON

EOF

cat <<EOF > /node2/my.cnf
[mysql]
socket=/node2/sock

[mysqld]
user=mysql
log_error=/node2/mysql.err
datadir=/node2
pid_file=/node2/mysql.pid
socket=/node2/sock
port=3308

innodb_buffer_pool_size=256M
innodb_log_file_size=256M
sync_binlog=0
innodb_flush_log_at_trx_commit=2
skip-innodb_doublewrite
innodb_old_blocks_time=1000
innodb_purge_threads=1
innodb_file_per_table=1
performance_schema=off

server-id=2

relay-log=relay
relay-log-index=relay.index

#plugin_load="rpl_semi_sync_master=semisync_master.so;rpl_semi_sync_slave=semisync_slave.so"
#rpl_semi_sync_master_enabled = ON
#rpl_semi_sync_slave_enabled = ON

EOF

cat <<EOF > /node3/my.cnf
[mysql]
socket=/node3/sock

[mysqld]
user=mysql
log_error=/node3/mysql.err
datadir=/node3
pid_file=/node3/mysql.pid
socket=/node3/sock
port=3309

innodb_buffer_pool_size=256M
innodb_log_file_size=256M
sync_binlog=0
innodb_flush_log_at_trx_commit=2
skip-innodb_doublewrite
innodb_old_blocks_time=1000
innodb_purge_threads=1
innodb_file_per_table=1
performance_schema=off

server-id=3

relay-log=relay
relay-log-index=relay.index

#plugin_load="rpl_semi_sync_master=semisync_master.so;rpl_semi_sync_slave=semisync_slave.so"
#rpl_semi_sync_master_enabled = ON
#rpl_semi_sync_slave_enabled = ON

EOF

/usr/local/mysql/bin/mysqld --defaults-file=/node1/my.cnf &

tail -F /node1/mysql.err | \
while read line ; do
  echo "$line" | grep "ready for connections"
  if [ $? = 0 ]
  then
    /usr/local/mysql/bin/mysql -S/node1/sock -e "CREATE USER 'r'@'localhost'"
    /usr/local/mysql/bin/mysql -S/node1/sock -e "GRANT REPLICATION SLAVE ON *.* TO 'r'@'localhost'"
    pkill -P $$ tail
  fi
done


/usr/local/mysql/bin/mysqld --defaults-file=/node2/my.cnf &

tail -F /node2/mysql.err | \
while read line ; do 
  echo "$line" | grep "ready for connections"
  if [ $? = 0 ]
  then
    echo "Running: CHANGE MASTER TO MASTER_HOST='127.0.0.1', MASTER_PORT=3307, MASTER_USER='r', MASTER_USE_GTID=current_pos"
    /usr/local/mysql/bin/mysql -S/node2/sock -e "CHANGE MASTER TO MASTER_HOST='127.0.0.1', MASTER_PORT=3307, MASTER_USER='r', MASTER_USE_GTID=current_pos"
    echo "Running: START SLAVE"
    /usr/local/mysql/bin/mysql -S/node2/sock -e "START SLAVE"
    pkill -P $$ tail
  fi
done

/usr/local/mysql/bin/mysqld --defaults-file=/node3/my.cnf &

tail -F /node3/mysql.err | \
while read line ; do
  echo "$line" | grep "ready for connections"
  if [ $? = 0 ]
  then
    echo "Running: CHANGE MASTER TO MASTER_HOST='127.0.0.1', MASTER_PORT=3307, MASTER_USER='r', MASTER_USE_GTID=current_pos"
    /usr/local/mysql/bin/mysql -S/node3/sock -e "CHANGE MASTER TO MASTER_HOST='127.0.0.1', MASTER_PORT=3307, MASTER_USER='r', MASTER_USE_GTID=current_pos"
    echo "Running: START SLAVE"
    /usr/local/mysql/bin/mysql -S/node3/sock -e "START SLAVE"
    pkill -P $$ tail
  fi
done


