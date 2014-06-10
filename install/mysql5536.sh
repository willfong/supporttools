wget http://downloads.mysql.com/archives/get/file/MySQL-5.5.36-1.linux2.6.x86_64.rpm-bundle.tar
tar xf MySQL-5.5.36-1.linux2.6.x86_64.rpm-bundle.tar
rpm -Uvh MySQL-client-5.5.36-1.linux2.6.x86_64.rpm MySQL-server-5.5.36-1.linux2.6.x86_64.rpm MySQL-shared-5.5.36-1.linux2.6.x86_64.rpm MySQL-shared-compat-5.5.36-1.linux2.6.x86_64.rpm
rm -rf MySQL-5.5.36-1.linux2.6.x86_64.rpm-bundle.tar
rm -rf *.rpm
