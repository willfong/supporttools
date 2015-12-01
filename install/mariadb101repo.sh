cat <<EOF > /etc/yum.repos.d/MariaDB101.repo
# MariaDB 10.1 RedHat repository list - created 2015-12-01 03:43 UTC
# http://mariadb.org/mariadb/repositories/
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.1/rhel6-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOF
