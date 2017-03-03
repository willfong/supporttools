#!/bin/bash
TIMEFORMAT=%R


mysql test -e "DROP TABLE IF EXISTS timed_inserts"
mysql test -e "CREATE TABLE timed_inserts ( a INT UNSIGNED PRIMARY KEY AUTO_INCREMENT, b DATETIME, c INT UNSIGNED)"


trap 'break' INT

NUMBER=0

while true
do
  NUMBER=$((NUMBER+1))
  echo -n `date +"%T.%3N"` --\ 
  echo -n "# $NUMBER  Execution time: "
  time mysql test -e "INSERT INTO timed_inserts (b, c) VALUES (NOW(), $NUMBER)"
  sleep 1
done


mysql test -e "SELECT COUNT(*) FROM timed_inserts"
