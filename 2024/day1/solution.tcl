#!/usr/bin/env tclsh

set input [open "input" r]
set l1 [list]
set l2 [list]

while {[gets $input line] >= 0} {
  regexp {^(\d+)\s+(\d+)} $line -> match1 match2
  lappend l1 $match1
  lappend l2 $match2
}
close $input
set l1 [lsort $l1]
set l2 [lsort $l2]

# Part 1
set sum 0
lmap a $l1 b $l2 {set sum [expr {$sum + abs($a - $b)}]}
puts "Part 1: $sum"

# Part 2
set sum 0
foreach val $l1 {
  foreach res [lsearch -all -inline $l2 $val] {
    if {$res != ""} {
      incr sum $res
    }
  }
}

puts "Part 2: $sum"
