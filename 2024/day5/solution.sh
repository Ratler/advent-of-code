#!/usr/bin/env bash

readarray -t input < input

declare -A pages
updates=()
incorrect_updates=()
part1=0
part2=0

for (( i=0; i<${#input[@]}; i++ )); do
  if [[ ${input[$i]} == "" ]]; then
    continue
  elif [[ ${input[$i]} =~ ^.*\| ]]; then
    v1="${input[$i]#*|}"
    v2="${input[$i]%|*}"

    if [[ ! -v pages["$v1"] ]]; then
      pages["$v1"]="$v2"
    else
      pages["$v1"]+=",$v2"
    fi
  elif [[ ${input[$i]} =~ ^.*, ]]; then
    updates+=(${input[$i]})
  fi
done

for update in "${updates[@]}"; do
  ok=true
  IFS="," read -r -a arr <<< "$update"
  for (( i=0; i<${#arr[@]}; i++ )); do
    ival="${arr[$i]}"

    if [[ -v pages[$ival] ]]; then
      IFS="," read -r -a arr2 <<< "${pages[$ival]}"

      for (( j=0; j<${#arr2[@]}; j++ )); do
        if (( arr[i + 1] == arr2[j] )); then
          ok=false
          incorrect_updates+=("$update")
          break
        fi
      done

      if ! $ok; then
        break
      fi
    fi
  done

  if $ok; then
    (( part1+="${arr[${#arr[@]} / 2 ]}" ))
  fi
done

for update in "${incorrect_updates[@]}"; do
  i=0
  IFS="," read -r -a arr <<< "$update"

  while (( i < ${#arr[@]} )); do
    j=$(( ${#arr[@]} - 1 ))
    while (( i < j )); do
      if [[ -v pages[${arr[$j]}] ]]; then
        if [[ ${pages[${arr[$i]}]} =~ .*${arr[$j]}.* ]]; then
          new_i=${arr[$i]}
          new_j=${arr[$j]}
          arr[i]=$new_j
          arr[j]=$new_i
          j=$(( ${#arr[@]} - 1 ))
        else
          j=$(( j - 1 ))
        fi         
      else
        break
      fi
   done
   (( i++ ))
  done
  (( part2+=${arr[${#arr[@]} / 2]} ))
done

echo "Part 1: $part1"
echo "Part 2: $part2"
