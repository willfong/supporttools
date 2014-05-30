wget http://downloads.mysql.com/archives/get/file/MySQL-5.6.12-2.el6.x86_64.rpm-bundle.tar
tar xvf MySQL-5.6.12-2.el6.x86_64.rpm-bundle.tar
rpm -Uvh MySQL-shared-5.6.12-2.el6.x86_64.rpm MySQL-server-5.6.12-2.el6.x86_64.rpm MySQL-client-5.6.12-2.el6.x86_64.rpm MySQL-shared-compat-5.6.12-2.el6.x86_64.rpm
rm -rf *.rpm
rm -rf MySQL-5.6.12-2.el6.x86_64.rpm-bundle.tar
service mysql start
./reset_mysql_password.sh
