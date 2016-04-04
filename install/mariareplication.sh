URL=http://downloads.mariadb.com/files/MariaDB/mariadb-10.0.22/bintar-linux-x86_64/mariadb-10.0.22-linux-x86_64.tar.gz

yum -y install libaio
rpm -Uvh http://downloads.mariadb.com/files/MariaDB/mariadb-10.1.8/yum/centos6-amd64/rpms/jemalloc-3.6.0-1.el6.x86_64.rpm
groupadd mysql
useradd -r -g mysql mysql
cd /usr/local
wget $URL
tar xvzf m*.tar.gz
ls -d m*/ | xargs -I dirname ln -s dirname mysql
cd mysql
chown -R mysql .
chgrp -R mysql .
rm -rf /var/lib/mysql
mkdir /master
mkdir /slave
scripts/mysql_install_db --user=mysql --datadir=/master
scripts/mysql_install_db --user=mysql --datadir=/slave
chown -R root .
chown -R mysql /master
chown -R mysql /slave

cat <<EOF > /etc/my-master.cnf
[mysql]
socket=/master/mysql.sock

[mysqld]
user=mysql
log_error=/master/mysql.err
datadir=/master
pid_file=/master/mysql.pid
socket=/master/mysql.sock
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


EOF

cat <<EOF > /etc/my-slave.cnf
[mysql]
socket=/slave/mysql.sock

[mysqld]
user=mysql
log_error=/slave/mysql.err
datadir=/slave
pid_file=/slave/mysql.pid
socket=/slave/mysql.sock
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


EOF


/usr/local/mysql/bin/mysqld --defaults-file=/etc/my-master.cnf &

tail -F /master/mysql.err | \
while read line ; do
  echo "$line" | grep "ready for connections"
  if [ $? = 0 ]
  then
    /usr/local/mysql/bin/mysql -S/master/mysql.sock -e "CREATE USER 'r'@'localhost'"
    /usr/local/mysql/bin/mysql -S/master/mysql.sock -e "GRANT REPLICATION SLAVE ON *.* TO 'r'@'localhost'"
    pkill -P $$ tail
  fi
done


/usr/local/mysql/bin/mysqld --defaults-file=/etc/my-slave.cnf &

tail -F /slave/mysql.err | \
while read line ; do 
  echo "$line" | grep "ready for connections"
  if [ $? = 0 ]
  then
    FILENAME="$(/usr/local/mysql/bin/mysql -S/master/mysql.sock -e 'SHOW MASTER STATUS\G'|grep 'File:' | cut -d ':' -f 2|awk '{$1=$1};1')"
    POS="$(/usr/local/mysql/bin/mysql -S/master/mysql.sock -e 'SHOW MASTER STATUS\G'|grep 'Position:' | cut -d ':' -f 2|awk '{$1=$1};1')"
    echo "Running: CHANGE MASTER TO MASTER_HOST='127.0.0.1', MASTER_PORT=3307, MASTER_USER='r', MASTER_LOG_FILE='${FILENAME}', MASTER_LOG_POS=${POS}"
    /usr/local/mysql/bin/mysql -S/slave/mysql.sock -e "CHANGE MASTER TO MASTER_HOST='127.0.0.1', MASTER_PORT=3307, MASTER_USER='r', MASTER_LOG_FILE='${FILENAME}', MASTER_LOG_POS=${POS}"
    echo "Running: START SLAVE"
    /usr/local/mysql/bin/mysql -S/slave/mysql.sock -e "START SLAVE"
    pkill -P $$ tail
  fi
done



