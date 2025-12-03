#!/usr/bin/env tclsh9.0

set input [open "input" r]

proc joltage {pack n} {
  set r ""; set p -1; set l [string length $pack]

  for {set i 0} {$i < $n} {incr i} {
    set remaining [expr $n - $i - 1]
    set maxNum 0; set maxIndex [expr $p + 1]

    for {set j [expr $p + 1]} {$j < [expr $l - $remaining]} {incr j} {
      set cur [string index $pack $j]
      if {$cur > $maxNum} { set maxNum $cur; set maxIndex $j }
    }

    append r $maxNum
    set p $maxIndex
  }

  return $r
}

set p1 0; set p2 0

while {[gets $input line] >= 0} {
 set p1 [expr $p1 + [joltage $line 2]]
 set p2 [expr $p2 + [joltage $line 12]]
}

puts "Part 1: $p1"
puts "Part 2: $p2"

