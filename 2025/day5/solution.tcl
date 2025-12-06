#!/usr/bin/env tclsh9.0

set fp [open "input" r]
set ranges {}
set ingredients {}
set collectRanges 1

while {[gets $fp line] >= 0} {
  if {[string equal $line ""]} {
    set collectRanges 0
  }

  if {$collectRanges == 1} {
    lappend ranges "$line"
  } else {
    lappend ingredients "$line"
  }
}
close $fp 

proc inRange {id ranges} {
  foreach range $ranges {
    lassign [split $range -] start end
    if {$id >= $start && $id <= $end} {
      return 1
    }
  }
  return 0
}

proc mergeRanges {ranges} {
  set sortedRanges [lsort -unique -command {apply {{a b} {
    lassign [split $a -] aStart aEnd
    lassign [split $b -] bStart bEnd
    if {$aStart < $bStart} {return -1}
    if {$aStart > $bStart} {return 1}
    if {$aEnd < $bEnd} {return -1}
    if {$aEnd > $bEnd} {return 1}
    return 0
  }}} $ranges]

  set merged {}
  set currentRange ""

  foreach range $sortedRanges {
    if {$currentRange eq ""} {
      set currentRange $range
    } else {
      lassign [split $currentRange -] currentStart currentEnd
      lassign [split $range -] nextStart nextEnd

      if {$nextStart <= $currentEnd} {
        set currentRange "[expr min($currentStart,$nextStart)]-[expr max($currentEnd,$nextEnd)]"
      } else {
        lappend merged $currentRange
        set currentRange $range
      }
    }
  }
  if {$currentRange ne ""} {
    lappend merged $currentRange
  }

  set uniqueCount 0
  foreach range $merged {
    lassign [split $range -] start end
    set uniqueCount [expr {$uniqueCount + ($end - $start + 1)}]
  }

  return $uniqueCount
}

foreach id $ingredients {
  if {[inRange $id $ranges]} {
    incr part1
  }
}

puts "Part 1: $part1"
puts "Part 2: [mergeRanges $ranges]"

