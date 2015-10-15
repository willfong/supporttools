yum -y install epel-release
yum -y install https://72003f4c60f5cc941cd1c7d448fc3c99e0aebaa8.googledrive.com/host/0B1lu97m8-haWeHdGWXp0YVVUSlk/mha4mysql-manager-0.57-0.el7.noarch.rpm https://72003f4c60f5cc941cd1c7d448fc3c99e0aebaa8.googledrive.com/host/0B1lu97m8-haWeHdGWXp0YVVUSlk/mha4mysql-node-0.57-0.el7.noarch.rpm

echo "
MHA needs a user to connect to the servers as. Something like:
GRANT ALL ON *.* TO 'mha'@'%' IDENTIFIED BY 'mha';

Sample Config:
[server default]
# mysql user and password
user=mha
password=mha
ssh_user=root
  
[server1]
hostname=host1
 
[server2]
hostname=host2

Run Checks:
masterha_check_ssh --conf=/etc/app1.cnf
masterha_check_repl --conf=/etc/app1.cnf

All nodes need to be able to be a master and slave. So you need log-bin and relaylog defined. 
"
