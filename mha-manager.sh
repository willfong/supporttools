yum -y install perl-DBD-MySQL perl-Config-Tiny perl-MIME-Lite perl-Email-Date-Format perl-Time-HiRes perl-Params-Validate
rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/perl-Log-Dispatch-2.27-1.el6.noarch.rpm http://dl.fedoraproject.org/pub/epel/6/x86_64/perl-Parallel-ForkManager-0.7.9-1.el6.noarch.rpm http://dl.fedoraproject.org/pub/epel/6/x86_64/perl-Mail-Sender-0.8.16-3.el6.noarch.rpm http://dl.fedoraproject.org/pub/epel/6/x86_64/perl-Mail-Sendmail-0.79-12.el6.noarch.rpm https://googledrive.com/host/0B1lu97m8-haWeHdGWXp0YVVUSlk/mha4mysql-manager-0.56-0.el6.noarch.rpm https://googledrive.com/host/0B1lu97m8-haWeHdGWXp0YVVUSlk/mha4mysql-node-0.56-0.el6.noarch.rpm

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
