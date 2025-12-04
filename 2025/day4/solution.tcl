#!/usr/bin/env tclsh9.0
#
#   0 1 2 3 4 5 6 6 7 8
# 0 . . @ @ . @ @ @ @ .
# 1 @ @ @ . @ . @ . @ @
# 2 @ @ @ @ @ . @ . @ @
# 3 @ . @ @ @ @ . . @ .
# 4 @ @ . @ @ @ @ . @ @
# 5 . @ @ @ @ @ @ @ . @
# 6 . @ . @ . @ . @ @ @
# 7 @ . @ @ @ . @ @ @ @
# 8 . @ @ @ @ @ @ @ @ .
# 9 @ ,. @ . @ @ @ . @ .


array set paperGrid {}

set fp [open "input" r]
set cols 0; set rows 0

set directions { {-1 0} {1 0} {0 -1} {0 1} {-1 -1} {-1 1} {1 -1} {1 1} }

proc checkAdjacent {x y} {
  global cols rows directions paperGrid
  set rolls 0
  if {[set paperGrid($x,$y)] == "."} {
    return 0
  }
  foreach d $directions {
    set nX [expr {$x + [lindex $d 0]}]
    set nY [expr {$y + [lindex $d 1]}]

    if {$nX >= 0 && $nX < $cols && $nY >= 0 && $nY < $rows} {
      if {[set paperGrid($nX,$nY)] == "@"} {
        incr rolls
      }
    }
  }
  return [expr {$rolls < 4}]
}

while {[gets $fp line] >= 0} {
  if {$rows == 0} { set cols [string length $line] }
  for {set j 0} {$j < [string length $line]} {incr j} {
    set paperGrid($rows,$j) [string index $line $j]
  }
  incr rows
}

close $fp

set part1 0; set part2 0

for {set i 0} {$i < $rows} {incr i} {
  for {set j 0} {$j < $cols} {incr j} {
    if {[checkAdjacent $i $j]} {
      incr part1
    }
  }
}

set done ""

while {$done != 0} { 
  set remove {}

  for {set i 0} {$i < $rows} {incr i} {
    for {set j 0} {$j < $cols} {incr j} {
      if {[checkAdjacent $i $j]} {
        lappend remove "$i $j"
        incr part2
      }
    }
  }
  if {[llength $remove] > 0} {
    foreach r $remove {
      set paperGrid([lindex $r 0],[lindex $r 1]) "."
    }
  } else {
    set done 0
  }
}

puts "Part 1: $part1"
puts "Part 2: $part2"
