wget http://downloads.mysql.com/archives/get/file/MySQL-5.6.15-1.el6.x86_64.rpm-bundle.tar
tar xvf MySQL-*.rpm-bundle.tar
rpm -Uvh MySQL-shared-*.rpm MySQL-server-*.rpm MySQL-client-*.rpm MySQL-shared-compat-*.rpm MySQL-devel
rm -rf *.rpm
rm -rf MySQL-*.rpm-bundle.tar
