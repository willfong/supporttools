#!/bin/bash

# Stuff that might need to be changed
SYSB="sysbench/sysbench/sysbench --test=sysbench/sysbench/tests/db/oltp.lua --mysql-host=127.0.0.1 --mysql-port=3306 --mysql-user=root --mysql-password= --mysql-db=test --mysql-table-engine=innodb --mysql-ignore-duplicates=on --oltp-read-only=off --oltp-dist-type=uniform --oltp-skip-trx=off --init-rng=on --oltp-test-mode=complex --max-requests=0 --report-interval=60"

CLI="mysql"
DATADIR="/var/lib/mysql/test"



THREADS=$(($(cat /proc/cpuinfo |grep "processor" | wc -l) * 2))
RESULTFILE="results-$(date +%Y%m%d%H%M%S).txt"


# printlog <logline>
function printlog {
  echo "[$(date +"%F %T")]  $1"
}

# prepare
function prepare {
  printlog "Preparing $TABLES tables with $ROWS rows..."
  echo "# Tables: $TABLES, Rows: $ROWS" > $RESULTFILE
  $SYSB --max-time=60 --oltp-tables-count=$TABLES --oltp-table-size=$ROWS prepare > /dev/null
  echo "# $(du -sh $DATADIR)" >> $RESULTFILE
  printlog "Writing results to: $RESULTFILE"
}

# warmup
function warmup {
  printlog "Warming up for $WARMUP seconds..."
  $SYSB --num-threads=$THREADS --oltp-tables-count=$TABLES --oltp-table-size=$ROWS --max-time=$WARMUP run > /dev/null
}

# runfor
function runfor {
  printlog "Running test with $THREADS threads for $RUNTIME seconds..."
  if [ ! -z $HEADER ]; then echo $HEADER"_tps,"$HEADER"_reads,"$HEADER"_writes,"$HEADER"_response" >> $RESULTFILE; fi
  $SYSB --num-threads=$THREADS --oltp-tables-count=$TABLES --oltp-table-size=$ROWS --max-time=$RUNTIME run | grep "tps: " | sed 's/ //g' | cut -d, -f 2,3,4,5 | sed 's/[a-zA-Z]//g' | sed 's/(95%)//g' | sed 's/://g' >> $RESULTFILE
}

# cleanup
function cleanup {
  printlog "Cleaning up tables..."
  $CLI -BNe "SHOW TABLES LIKE 'sbtest%'" test | xargs -I ID $CLI -e "DROP TABLE ID" test
}

function show_help {
  echo "Usage: $0 <tables> <rows> <warmup> <runtime> [header (optional)]"
}

if [ $# -lt 4 ]; then
  show_help
  exit 1
else
  TABLES=$1
  ROWS=$2
  WARMUP=$3
  RUNTIME=$4
  HEADER=$5
fi

# The process

cleanup
prepare
warmup
runfor
cleanup
