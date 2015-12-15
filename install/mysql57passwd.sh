cat << EOF > ~/.my.cnf
[mysql]
password=`cat /var/log/mysqld.log |grep "temporary password" | cut -d " " -f 11`
EOF

