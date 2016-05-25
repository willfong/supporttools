#!/bin/bash

function show_help {
  echo "Usage: $0 <sleep> <command>"
  echo "Make sure to quote the command"
}

if [ $# -ne 2 ]; then
  show_help
  exit 1
else
  START=0
  SLEEP=$1
  CMD=$2
fi

while true; do
  eval OUTPUT=\`$CMD\`
  echo "$START,$OUTPUT"
  sleep $SLEEP
  START=$(($START+$SLEEP))
done

