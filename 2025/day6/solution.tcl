#!/usr/bin/env tclsh9.0

proc readFile {f} {
  set lines {}
  set fh [open $f r]

  while {[gets $fh line] >= 0} {
    set line [string trim $line]
    regsub -all { +} $line { } line
    lappend lines [split $line " "]
  }
  close $fh

  set opRow [lindex $lines end]
  set nrRows [lrange $lines 0 end-1]
  set data {}

  for {set col 0} {$col < [llength $opRow]} {incr col} {
    set op [lindex $opRow $col]
    set numbers {}

    foreach row $nrRows {
      set ch [lindex $row $col]
      lappend numbers $ch
    }
    lappend data [list $op $numbers]
  }

  return $data
}

proc readFilePart2 {f} {
  set lines {}
  set fh [open $f r]
  while {[gets $fh line] >= 0} {
    lappend lines $line
  }
  close $fh

  set maxLen 0
  foreach line $lines {
    if {[string length $line] > $maxLen} {
      set maxLen [string length $line]
    }
  }

  set paddedLines {}
  foreach line $lines {
    lappend paddedLines [format "%-${maxLen}s" $line]
  }

  set opRow [lindex $paddedLines end]
  set nrRows [lrange $paddedLines 0 end-1]
  set data {}; set curData {}; set curOp ""

  for {set col [expr {$maxLen - 1}]} {$col >= 0} {incr col -1} {
    set op [string index $opRow $col]
    set numbers ""

    foreach row $nrRows {
      set ch [string index $row $col]
      if {$ch ne " "} {
        append numbers $ch
      }
    }

    if {$numbers eq "" && $op eq " "} {
      if {[llength $curData] > 0} {
        lappend data [list $curOp $curData]
        set curData {}
        set curOp ""
      }
    } else {
      if {$op ne " "} {
        set curOp $op
      }
      if {$numbers ne ""} {
        lappend curData $numbers
      }
    }
  }

  if {[llength $curData] > 0} {
    lappend data [list $curOp $curData]
  }

  return $data
}

proc calculate {data} {
  set result 0

  foreach d $data {
    set op [lindex $d 0]
    set numbers [lindex $d 1]
    set expression [join $numbers " $op "]
    set tmpRes [expr $expression]
    set result [expr {$result + $tmpRes}]
  }

  return $result
}
set fn "input"
set data [readFile $fn]
puts "Part 1: [calculate $data]"

set data [readFilePart2 $fn]
puts "Part 2: [calculate $data]"
