wget http://`cat /webserver.txt`/mysql/MariaDB-5.5.33a-centos6-x86_64-client.rpm
wget http://`cat /webserver.txt`/mysql/MariaDB-5.5.33a-centos6-x86_64-common.rpm
wget http://`cat /webserver.txt`/mysql/MariaDB-5.5.33a-centos6-x86_64-compat.rpm
wget http://`cat /webserver.txt`/mysql/MariaDB-5.5.33a-centos6-x86_64-server.rpm
wget http://`cat /webserver.txt`/mysql/MariaDB-5.5.33a-centos6-x86_64-shared.rpm
rpm -Uvh *.rpm
rm -rf *.rpm
/root/deploy_scripts/mariaconf.sh
