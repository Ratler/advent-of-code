#!/usr/bin/env tclsh9.0

set input [open "input" r]
gets $input line
set idList [split $line ","]

proc isInvalidId {id matchAll} {
  if {$matchAll == 1} {
    set pattern {^(\d+)\1+$}
  } else {
    set pattern {^(\d+)\1$}
  }

  if {[regexp $pattern $id]} {
    return 1
  }

  return 0
}

proc invalidSum {min max part2} {
  set sum 0

  for {set i $min} {$i <= $max} {incr i 1} {
    if {[isInvalidId $i $part2]} {
      set sum [expr $sum + $i]
    }
  }

  return $sum
}

set part1 0
set part2 0

foreach idRange $idList {
  set r1 [lindex [split $idRange -] 0]
  set r2 [lindex [split $idRange -] 1]
  set part1 [expr $part1 + [invalidSum $r1 $r2 0]]
  set part2 [expr $part2 + [invalidSum $r1 $r2 1]]
}

puts "Part 1: $part1"
puts "Part 2: $part2"
