#!/usr/bin/env tclsh9.0

proc dial_iterator {fp} {
  yield [info coroutine]

  while {[gets $fp line] >= 0} {
    regexp {^([LR])(\d+)} $line -> direction number
    if {$direction == "R"} {
      set operator "+"
    } else {
      set operator "-"
    }
    yield [list $operator $number]
  }
  return -code break "EOF"
}

proc solver { fp } {
  set password 0
  set password2 0
  set clockVal 50

  coroutine nextMove dial_iterator $fp

  while 1 {
    if {[catch {lassign [nextMove] operator number} err]} {
      break;
    }

    set expression "$clockVal $operator $number"
    set val [eval expr {$expression}]

    if {$clockVal == 0 || $val > 0} {
      incr password2 [expr {abs(int($val / 100.0))}]
    } else {
      incr password2 [expr {abs(int(($val / 100.0) - 1))}]
    }

    set clockVal [expr $val % 100]

    if {$clockVal == 0} {
      incr password 1
    }
  }
  puts "Part1: $password"
  puts "Part2: $password2"
}


set fp [open "input" r]

solver $fp

