yum -y groupinstall "Development Tools"
yum -y install bzr
yum -y install mysql-devel
bzr branch lp:~percona-dev/perconatools/tpcc-mysql
cd tpcc-mysql/src
make
cd ..

echo "

Setup:
  cd ~/tpcc-mysql
  mysql -u root -p -e "CREATE DATABASE tpcc1000;"
  mysql -u root -p tpcc1000 < create_table.sql
  mysql -u root -p tpcc1000 < add_fkey_idx.sql

Load data:
  ./tpcc_load 127.0.0.1 tpcc1000 root "root-password" 20
  (20 warehouses == 1.9GB of data)

Run test:
  ./tpcc_start -h127.0.0.1 -dtpcc1000 -uroot -p -w20 -c16 -r10 -l1200
  (w=warehouse, c=connections, r=rampup seconds, l=measure seconds)

Reference:

  http://www.mysqlperformanceblog.com/2013/07/01/tpcc-mysql-simple-usage-steps-and-how-to-build-graphs-with-gnuplot/
  http://bazaar.launchpad.net/~percona-dev/perconatools/tpcc-mysql/view/head:/README

"
