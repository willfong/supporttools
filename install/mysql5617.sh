yum -y install libaio
wget http://dev.mysql.com/get/Downloads/MySQL-5.6/MySQL-5.6.17-1.el6.x86_64.rpm-bundle.tar
tar xvf MySQL-*-bundle.tar
rpm -Uvh MySQL-devel-*.rpm MySQL-shared-*.rpm MySQL-server-*.rpm MySQL-client-*.rpm MySQL-shared-compat-*.rpm
rm -rf *.rpm
rm -rf MySQL-*-bundle.tar
echo "Remember to run: reset_mysql_password.sh"
