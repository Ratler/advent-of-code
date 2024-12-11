#!/usr/bin/env bash

readarray -t input < input
declare -A path
rows=${#input[@]}
cols=${#input[0]}
sum=0
x=0
y=0

# right=0, down=1, left=2, up=3
direction=3 # assume up at start

#    0 1 2 3 4 5 6 7 8 9
# 0  . . . . # . . . . .
# 1  . . . . . . . . . #
# 2  . . . . . . . . . .
# 3  . . # . . . . . . .
# 4  . . . . . # . . . .
# 5  . . . . . . . . . .
# 6  . # . . ^ . . . . .
# 7  . . . . . . . . # .
# 8  # . . . . . . . . .
# 9  . . . . . # . . . .
#


debug() {
  echo "debug($*)" >&2
}

turn_right() {
  direction=$(( (direction + 1) % 4 ))
}

step_foward() {
  case $direction in
    0) ((y++)) ;;
    1) ((x++)) ;;
    2) ((y--)) ;;
    3) ((x--)) ;;
  esac
}

check_obstacle() {
  case $direction in
    0) echo "$x,$((y + 1))" ;;
    1) echo "$((x + 1)),$y" ;; 
    2) echo "$x,$((y - 1))" ;;
    3) echo "$((x - 1)),$y" ;;
  esac
}

check_valid_move() {
  if (( x < 0 || x >= rows || y < 0 || y >= cols )); then
    return 2
  fi

  o=$(check_obstacle)
  if [[ ${input[${o%,*}]:${o#*,}:1} == "#" ]]; then
    return 1
  fi

  return 0
}

add_pos_to_path() {
  if [[ -v path["$x,$y"] ]]; then
    path["$x,$y"]=$(( path["$x,$y"] + 1 ))
    return 1
  else
    path["$x,$y"]=1
    (( sum++ ))
  fi
  return 0
}

find_starting_position() {
  for (( i=0; i<rows; i++ )); do
    for (( j=0; j<cols; j++ )); do
      if [[ ${input[i]:j:1} == "^" ]]; then
        x=$i
        y=$j
        add_pos_to_path
      fi
    done
  done
}

part1() {
  find_starting_position

  while true; do
    check_valid_move
    case $? in
      0)
        add_pos_to_path
        step_foward 
        ;;
      1) turn_right ;;
      2) break ;;
    esac
  done

  echo "$sum"
}

debug "grid size: $rows x $cols"
echo "Part 1: $(part1)"
