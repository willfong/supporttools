wget http://downloads.mysql.com/archives/get/file/MySQL-5.5.36-1.linux2.6.x86_64.rpm-bundle.tar
tar xf MySQL-5.5.36-1.linux2.6.x86_64.rpm-bundle.tar
rpm -Uvh MySQL-devel-*.rpm MySQL-shared-*.rpm MySQL-server-*.rpm MySQL-client-*.rpm MySQL-shared-compat-*.rpm
rm -rf MySQL-5.5.36-1.linux2.6.x86_64.rpm-bundle.tar
rm -rf *.rpm
