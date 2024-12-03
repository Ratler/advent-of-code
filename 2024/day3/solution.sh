#!/usr/bin/env bash

readarray -t memory < input

main() {
  local sum=0
  local regex="$1"
  local do=true

  for v in "${memory[@]}"; do
    for (( i=0; i<${#v}; i++ )); do
      substring="${v:$i}"
      
      if [[ $substring =~ $regex ]]; then
        match="${BASH_REMATCH[0]}"
        (( i+=${#match}-1 ))

        if [[ $match == "do()" ]]; then
          do=true
        elif [[ $match == "don't()" ]]; then
          do=false
        elif $do; then
          val="${match/mul(/}"
          val="${val/)/}"
          (( sum+=${val/,/*} ))
        fi
      fi
    done
  done
  echo "$sum"
}

echo "Part 1: $(main "^mul\([0-9]+,[0-9]+\)")"
echo "Part 2: $(main "^(mul\([0-9]+,[0-9]+\)|do\(\)|don't\(\))")"
