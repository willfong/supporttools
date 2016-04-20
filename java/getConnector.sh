wget https://downloads.mariadb.com/enterprise/he05-e19h/connectors/java/connector-java-1.4.2/mariadb-java-client-1.4.2.jar
wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.38.tar.gz
tar xzvf mysql-connector-java-5.1.38.tar.gz mysql-connector-java-5.1.38/mysql-connector-java-5.1.38-bin.jar
mv mysql-connector-java-5.1.38/mysql-connector-java-5.1.38-bin.jar .
rm -rf mysql-connector-java-5.1.38/ mysql-connector-java-5.1.38.tar.gz
