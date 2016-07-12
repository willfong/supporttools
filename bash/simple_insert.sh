#!/bin/bash

if [ -z $1 ]
then
    echo "Need to specify number of inserts."
    echo "Usage: $0 <inserts>"
    exit
else
    INSERTS=$1
fi


PORT=4308
SLEEP=10

i="1"


$(mysql -h127.0.0.1 -P$PORT -uw -pw -e "CREATE TABLE IF NOT EXISTS test.count_up ( id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT, created_time DATETIME, value INT UNSIGNED )")

while [ $i -le $INSERTS ]; do
  if ($(mysql -h127.0.0.1 -P$PORT -uw -pw -e "INSERT INTO test.count_up ( created_time, value ) VALUES ( NOW(), $i )")); then
    echo -n "."
  else
    echo "Error! Sleeping for $SLEEP seconds..."
    sleep $SLEEP
    if ($(mysql -h127.0.0.1 -P$PORT -uw -pw -e "INSERT INTO test.count_up ( created_time, value ) VALUES ( NOW(), $i )")); then
      echo "2nd try inserted $i"
    else
      echo "Error on second try $i"
    fi
  fi
  i=$[$i+1]
done

echo "Inserted $INSERTS rows!"
