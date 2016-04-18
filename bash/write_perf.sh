#!/bin/bash

if [ $# -ne 2 ]; then
  echo "Need to specify datadir and sleep interval."
  echo "Usage: $0 <datadir> <seconds>"
  exit 1
else
  DATADIR=$1
  SLEEP=$2
fi


echo "Looking for files in: $DATADIR..."
files=($(find $DATADIR | grep -e ".ibd$"))

declare -A filename=()

for i in "${files[@]}"; do
  filename[$i]=$(du -b $i | cut -f1 -d '        ')
done

echo "Waiting for $SLEEP seconds..."
sleep $SLEEP

for i in "${!filename[@]}"; do

  newfilesize=$(du -b $i | cut -f1 -d ' ')

  if [ $newfilesize -gt ${filename[$i]} ]; then
    rate=$(echo "scale=1; ($newfilesize - ${filename[$i]})/$SLEEP" | bc |  numfmt --to=iec-i --suffix=B )
    echo "File: $i @ $rate/sec"
  fi

done

