#wget http://`cat /webserver.txt`/mysql/MariaDB-10.0.4-centos6-x86_64-cassandra-engine.rpm
wget http://`cat /webserver.txt`/mysql/MariaDB-10.0.4-centos6-x86_64-client.rpm
wget http://`cat /webserver.txt`/mysql/MariaDB-10.0.4-centos6-x86_64-common.rpm
wget http://`cat /webserver.txt`/mysql/MariaDB-10.0.4-centos6-x86_64-compat.rpm
#wget http://`cat /webserver.txt`/mysql/MariaDB-10.0.4-centos6-x86_64-connect-engine.rpm
wget http://`cat /webserver.txt`/mysql/MariaDB-10.0.4-centos6-x86_64-server.rpm
wget http://`cat /webserver.txt`/mysql/MariaDB-10.0.4-centos6-x86_64-shared.rpm
rpm -Uvh *.rpm
rm -rf *.rpm
/root/deploy_scripts/mariaconf.sh
