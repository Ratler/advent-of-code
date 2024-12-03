#!/usr/bin/env bash

readarray -t memory < input

main() {
  local sum=0
  local regex="$1"

  for v in "${memory[@]}"; do
    for (( i=0; i<${#v}; i++ )); do
      substring="${v:$i}"
      
      if [[ $substring =~ $regex ]]; then
        match="${BASH_REMATCH[0]}"
        (( i+=${#match}-1 ))

        val="${match/mul(/}"
        val="${val/)/}"
        (( sum+=${val/,/*} ))
      fi
    done
  done
  echo "$sum"
}

main "^mul\([0-9]+,[0-9]+\)"
