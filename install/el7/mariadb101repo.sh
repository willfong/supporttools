cat <<EOF > /etc/yum.repos.d/MariaDB101.repo
# MariaDB 10.1 CentOS repository list - created 2015-11-24 04:28 UTC
# http://mariadb.org/mariadb/repositories/
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.1/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1

EOF
