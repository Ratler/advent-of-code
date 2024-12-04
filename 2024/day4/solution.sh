#!/usr/bin/env bash

readarray -t input < input
rows=${#input[@]}
cols=${#input[0]}
search_dir=("0 1" "1 0" "1 1" "1 -1" "-1 1" "-1 -1" "0 -1" "-1 0")

#    0  1  2  3  4  5  6  7  8  9
# 0  M  M  M  S  X  X  M  A  S  M
# 1  M  S  A  M  X  M  S  M  S  A
# 2  A  M  X  S  X  M  A  A  M  M
# 3  M  S  A  M  A  S  M  S  M  X
# 4  X  M  A  S  A  M  X  A  M  M
# 5  X  X  A  M  M  X  X  A  M  A
# 6  S  M  S  M  S  A  S  X  S  S
# 7  S  A  X  A  M  A  S  A  A  A
# 8  M  A  M  M  M  X  M  M  M  M
# 9  M  X  M  X  A  X  M  A  S  X


debug() {
  echo "debug($*)" >&2
}

search_direction() {
  local word idx x y dir_x dir_y word_size
  word="$1"
  idx="$2"
  x="$3"
  y="$4"
  dir_x="$5"
  dir_y="$6"
  word_size="${#word}"

  if (( x >= 0 && x < rows && y >= 0 && y < cols )) && [[ "${word:$idx:1}" == "${input[$x]:$y:1}" ]]; then
    if (( idx == word_size - 1 )); then
      return 0
    fi
    if search_direction "$word" "$(( idx + 1 ))" "$(( x + dir_x ))" "$(( y + dir_y ))" "$dir_x" "$dir_y"; then
      return 0
    fi
  fi
  return 1
}

search() {
  local word sum
  word="$1"
  sum=0

  for (( i=0; i<rows; i++ )); do
    for (( j=0; j<cols; j++ )); do
      if [[ ${input[i]:j:1} == "${word:0:1}" ]]; then
        c=0
        while [[ $c -lt ${#search_dir[@]} ]]; do
          read -r dir_x dir_y <<< "${search_dir[$c]}" 
          if search_direction "$word" 0 "$i" "$j" "$dir_x" "$dir_y"; then
            (( sum++ ))
          fi
          (( c++ ))
        done 
      fi
    done
  done

  echo $sum
}
# M M S S M S
#  A   A   A
# S S M M M S
part2() {
  local sum
  sum=0
  regex='MSSM|SMMS|SMSM|MSMS'

  for (( i=1; i<rows-1 ; i++ )); do
    for (( j=1; j<cols-1 ; j++ )); do
      if [[ ${input[i]:j:1} == "A" && "${input[i+1]:j-1:1}${input[i-1]:j+1:1}${input[i+1]:j+1:1}${input[i-1]:j-1:1}" =~ $regex ]]; then
        (( sum++ ))
      fi
    done
  done

  echo $sum
}

debug "grid size: $rows x $cols"
echo "Part 1: $(search "XMAS")"
echo "Part 2: $(part2)"
