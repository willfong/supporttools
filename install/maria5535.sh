wget http://ftp.osuosl.org/pub/mariadb/mariadb-5.5.35/yum/centos6-amd64/rpms/MariaDB-5.5.35-centos6-x86_64-client.rpm
wget http://ftp.osuosl.org/pub/mariadb/mariadb-5.5.35/yum/centos6-amd64/rpms/MariaDB-5.5.35-centos6-x86_64-common.rpm
wget http://ftp.osuosl.org/pub/mariadb/mariadb-5.5.35/yum/centos6-amd64/rpms/MariaDB-5.5.35-centos6-x86_64-compat.rpm
wget http://ftp.osuosl.org/pub/mariadb/mariadb-5.5.35/yum/centos6-amd64/rpms/MariaDB-5.5.35-centos6-x86_64-server.rpm
wget http://ftp.osuosl.org/pub/mariadb/mariadb-5.5.35/yum/centos6-amd64/rpms/MariaDB-5.5.35-centos6-x86_64-shared.rpm
yum -y install perl-DBI
rpm -Uvh *.rpm
rm -rf *.rpm
