#!/usr/bin/env bash

debug() {
  echo "debug($*)" >&2
}

main() {
  sum=0
  [[ "$1" == "part2" ]] && combinations=3 || combinations=2

  debug "combinations: $combinations"

  while IFS=":" read -r result val; do
    read -r -a values <<< "$val"
    num_values=${#values[@]}

    for ((i=0; i<combinations**(num_values-1); i++)); do
      res="${values[0]}"
      for ((j=0; j<num_values-1; j++)); do
         case $(( (i / (combinations**j)) % combinations )) in
           0) res="$(( res + values[$((j + 1))] ))" ;;
           1) res="$(( res * values[$((j + 1))] ))" ;;
           2) res="${res}${values[$((j + 1))]}" ;;
         esac
      done
      if [[ "$res" == "$result" ]]; then
        (( sum+=res ))
        break
      fi
    done
  done < input
  echo $sum
}

echo "Part1: $(main "part1")"
echo "Part2: $(main "part2")"
