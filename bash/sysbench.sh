#!/bin/bash

<<<<<<< HEAD
# Core Sysbench command
SYSB="sysbench/sysbench/sysbench --test=sysbench/sysbench/tests/db/oltp.lua --mysql-host=127.0.0.1 --mysql-port=3306 --mysql-user=root --mysql-password= --mysql-db=test --mysql-table-engine=innodb --mysql-ignore-duplicates=on --oltp-dist-type=uniform --oltp-skip-trx=off --init-rng=on --oltp-test-mode=complex --max-requests=0 --report-interval=60"
=======
# Stuff that might need to be changed
SYSB="sysbench/sysbench/sysbench --test=sysbench/sysbench/tests/db/oltp.lua --mysql-host=127.0.0.1 --mysql-port=3306 --mysql-user=root --mysql-password= --mysql-db=test --mysql-table-engine=innodb --mysql-ignore-duplicates=on --oltp-read-only=off --oltp-dist-type=uniform --oltp-skip-trx=off --init-rng=on --oltp-test-mode=complex --max-requests=0 --report-interval=60"
>>>>>>> 8e31bd9166e252ec92aa1d0c90e7bca16e003bed

CLI="mysql"
DATADIR="/var/lib/mysql/test"



THREADS=$(($(cat /proc/cpuinfo |grep "processor" | wc -l) * 2))
RESULTFILE="results-$(date +%Y%m%d%H%M%S).txt"
CLI=mariadb/bin/mysql


# printlog <logline>
function printlog {
  echo "[$(date +"%F %T")]  $1"
}

# prepare
function prepare {
  printlog "Preparing $TABLES tables with $ROWS rows..."
  echo "# Tables: $TABLES, Rows: $ROWS" > $RESULTFILE
  $SYSB --max-time=60 --oltp-tables-count=$TABLES --oltp-table-size=$ROWS prepare > /dev/null
<<<<<<< HEAD
  echo "# $(du -sh /data/db/maria14/test)" >> $RESULTFILE
  echo "# $($CLI -BNe "SHOW GLOBAL VARIABLES LIKE 'innodb_buffer_pool_size'")" >> $RESULTFILE
=======
  echo "# $(du -sh $DATADIR)" >> $RESULTFILE
>>>>>>> 8e31bd9166e252ec92aa1d0c90e7bca16e003bed
  printlog "Writing results to: $RESULTFILE"
}

# warmup
function warmup {
  printlog "Warming up for $WARMUP seconds..."
  $SYSB --oltp-read-only=on --num-threads=$THREADS --oltp-tables-count=$TABLES --oltp-table-size=$ROWS --max-time=$WARMUP run > /dev/null
}

# runfor
function runfor {
  printlog "Running test with $THREADS threads for $RUNTIME seconds..."
  if [ ! -z $HEADER ]; then echo $HEADER"_tps,"$HEADER"_reads,"$HEADER"_writes,"$HEADER"_response" >> $RESULTFILE; fi
  $SYSB --oltp-read-only=$ROMODE --num-threads=$THREADS --oltp-tables-count=$TABLES --oltp-table-size=$ROWS --max-time=$RUNTIME run | grep "tps: " | sed 's/ //g' | cut -d, -f 2,3,4,5 | sed 's/[a-zA-Z]//g' | sed 's/(95%)//g' | sed 's/://g' >> $RESULTFILE
}

# cleanup
function cleanup {
  printlog "Cleaning up tables..."
  $CLI -BNe "SHOW TABLES LIKE 'sbtest%'" test | xargs -I ID $CLI -e "DROP TABLE ID" test
}

function show_help {
  echo "Usage: $0 <tables> <rows> <rw|ro> <warmup> <runtime> [header (optional)]"
}

if [ $# -lt 5 ]; then
  show_help
  exit 1
else
  if [ $3 == 'ro' ]; then
    ROMODE='on'
  elif [ $3 == 'rw' ]; then
    ROMODE='off'
  else
    show_help
    exit 1
  fi
  TABLES=$1
  ROWS=$2
  WARMUP=$4
  RUNTIME=$5
  HEADER=$6
fi

# The process

cleanup
prepare
warmup
runfor
cleanup
