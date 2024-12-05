#!/usr/bin/env bash

readarray -t input < input
rows=${#input[@]}
cols=${#input[0]}
search_dir=("0 1" "1 0" "1 1" "1 -1" "-1 1" "-1 -1" "0 -1" "-1 0")

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

echo "Part 1: $(search "XMAS")"
echo "Part 2: $(part2)"
