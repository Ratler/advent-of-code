#!/usr/bin/env bash

readarray -t reports < input

check_report() {
  local report=($*) # Hack to turn the string into an array using default IFS
  local ascending=false
  dampener=${dampener:-false}

  if (( report[0] < report[1] )); then
    ascending=true 
  fi

  for ((i=0; i<${#report[@]}-1; i++)); do
    val=$((report[i+1] - report[i]))
    if $ascending && [[ "$val" -gt 0 ]] && [[ "$val" -lt 4 ]]; then
      continue
    elif ! $ascending && [[ "$val" -lt 0 ]] && [[ "$val" -gt -4 ]]; then
      continue
    elif $dampener; then
      # part 2: use the dampener to remove a faulty level
      for ((j=0; j<${#report[@]}; j++)); do
        if dampener=false check_report "${report[@]:0:$j} ${report[@]:$((j+1))}"; then
          return 0
        fi
      done
      return 1
    else
      return 1
    fi
  done

  return 0
}

for report in "${reports[@]}"; do
  if check_report "$report"; then
    (( reports_part1_ok++ ))
  fi
  if dampener=true check_report "$report"; then
    (( reports_part2_ok++ ))
  fi
done

echo "Part1: $reports_part1_ok"
echo "Part2: $reports_part2_ok"
