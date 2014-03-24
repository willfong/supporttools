wget http://`cat /webserver.txt`/mysql/MySQL-client-5.6.14-1.el6.x86_64.rpm
wget http://`cat /webserver.txt`/mysql/MySQL-server-5.6.14-1.el6.x86_64.rpm
wget http://`cat /webserver.txt`/mysql/MySQL-shared-5.6.14-1.el6.x86_64.rpm
wget http://`cat /webserver.txt`/mysql/MySQL-shared-compat-5.6.14-1.el6.x86_64.rpm
rpm -Uvh *.rpm
rm -rf *.rpm
service mysql start
./reset_mysql_password.sh
