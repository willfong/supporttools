#!/bin/bash
TIMEFORMAT=%R

while true
do
  echo -n `date +"%T.%3N"` --\  
  time mysql test -e "INSERT INTO test (b) VALUES (NOW())"
  sleep 1
done

