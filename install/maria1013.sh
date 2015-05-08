wget http://ftp.osuosl.org/pub/mariadb/mariadb-10.1.3/yum/centos6-amd64/rpms/MariaDB-10.1.3-centos6-x86_64-client.rpm
wget http://ftp.osuosl.org/pub/mariadb/mariadb-10.1.3/yum/centos6-amd64/rpms/MariaDB-10.1.3-centos6-x86_64-common.rpm
wget http://ftp.osuosl.org/pub/mariadb/mariadb-10.1.3/yum/centos6-amd64/rpms/MariaDB-10.1.3-centos6-x86_64-compat.rpm
wget http://ftp.osuosl.org/pub/mariadb/mariadb-10.1.3/yum/centos6-amd64/rpms/MariaDB-10.1.3-centos6-x86_64-devel.rpm
wget http://ftp.osuosl.org/pub/mariadb/mariadb-10.1.3/yum/centos6-amd64/rpms/MariaDB-10.1.3-centos6-x86_64-server.rpm
wget http://ftp.osuosl.org/pub/mariadb/mariadb-10.1.3/yum/centos6-amd64/rpms/MariaDB-10.1.3-centos6-x86_64-shared.rpm
wget http://ftp.osuosl.org/pub/mariadb/mariadb-10.1.3/yum/centos6-amd64/rpms/jemalloc-3.6.0-1.el6.x86_64.rpm

yum -y install perl-DBI
yum -y install *.rpm
rm -rf *.rpm
