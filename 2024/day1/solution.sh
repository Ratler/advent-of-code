#!/usr/bin/env bash

declare -A d2
readarray -t l1 < <(awk '{ print $1 | "sort -n" }' input)
readarray -t l2 < <(awk '{ print $2 | "sort -n" }' input)

if [[ "${#l1[@]}" != "${#l2[@]}" ]]; then 
  echo "Error: arrays are not the same length"
  exit 1
fi

# Part 1
sum=0
for ((i=0; i<${#l1[@]}; i++)); do
  diff=$(( l1[i] - l2[i] ))
  (( sum+=${diff#-} ))
done

echo "Part 1: $sum"

# Part 2
sum=0
for ((i=0; i<${#l2[@]}; i++)); do
  (( d2[${l2[i]}]++ ))
done

for ((i=0; i<${#l1[@]}; i++)); do
  if [[ -v d2[${l1[i]}] ]]; then
    (( sum+=${l1[$i]} * ${d2[${l1[i]}]} ))
  fi
done

echo "Part 2: $sum"
