wget http://dev.mysql.com/get/Downloads/MySQL-5.5/MySQL-5.5.43-1.el6.x86_64.rpm-bundle.tar
tar xf MySQL-5.5.43-1.el6.x86_64.rpm-bundle.tar
yum -y install libaio
rpm -Uvh MySQL-devel-*.rpm MySQL-shared-*.rpm MySQL-server-*.rpm MySQL-client-*.rpm MySQL-shared-compat-*.rpm
rm -rf MySQL*.rpm-bundle.tar
rm -rf *.rpm
