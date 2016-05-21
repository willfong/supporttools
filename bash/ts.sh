#!/bin/bash

function show_help {
  echo "Usage: $0 <sleep> <command>"
}

if [ $# -lt 2 ]; then
  show_help
  exit 1
else
  START=0
  SLEEP=$1
  shift
  CMD=$@
fi

while true; do
  OUTPUT=$($CMD)
  echo "$START,$OUTPUT"
  sleep $SLEEP
  START=$(($START+$SLEEP))  
done

