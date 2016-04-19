echo "

Users that need to be created for MaxScale:

CREATE USER 'maxscale'@'%' IDENTIFIED BY 'password';
GRANT SELECT ON mysql.user TO 'maxscale'@'%';
GRANT SELECT ON mysql.tables_priv TO 'maxscale'@'%';
GRANT SELECT ON mysql.db TO 'maxscale'@'%';
GRANT SHOW DATABASES ON *.* TO 'maxscale'@'%';
GRANT REPLICATION CLIENT ON *.* TO 'maxscale'@'%';
GRANT REPLICATION SLAVE ON *.* TO 'maxscale'@'%';

"
