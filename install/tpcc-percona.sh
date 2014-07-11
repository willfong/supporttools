yum -y groupinstall "Development Tools"
yum -y install bzr
yum -y install mysql-devel
bzr branch lp:~percona-dev/perconatools/tpcc-mysql
cd tpcc-mysql/src
make
cd ..

echo "

Reference:

  http://www.mysqlperformanceblog.com/2013/07/01/tpcc-mysql-simple-usage-steps-and-how-to-build-graphs-with-gnuplot/
  http://bazaar.launchpad.net/~percona-dev/perconatools/tpcc-mysql/view/head:/README

"
