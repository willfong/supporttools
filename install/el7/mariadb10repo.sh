cat <<EOF > /etc/yum.repos.d/MariaDB10.repo
# MariaDB 10.0 CentOS repository list - created 2015-01-30 01:41 UTC
# http://mariadb.org/mariadb/repositories/
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.0/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1

EOF
