#!/usr/bin/env bash

main() {
  local do_part2=${1:-false}
  local do=true

  while read match; do
    if [[ $match == "do()" ]]; then
      do=true
    elif [[ $match == "don't()" ]]; then
      do=false
    elif ! $do_part2 || ($do && $do_part2); then
      val="${match/mul/}"
      (( sum+=${val/,/*} ))
    fi
  done < <(rg -o "mul\([0-9]+,[0-9]+\)|do\(\)|don't\(\)" input)

  echo "$sum"
}

echo "Part 1: $(main false)"
echo "Part 2: $(main true)"
