#!/usr/bin/env bash

degrees=(I IV V)
chords=(C7 F7 G7)

listNextDegrees() {
  local __degree=$1
  local __next=$2
  case $__degree in
    I)
      eval $__next='("I" "IV" "V")';;
    IV)
      eval $__next='("IV" "I")';;
    V)
      eval $__next='("IV" "I")';;
    *)
      echo Unrecognized chord $__degree
      exit 1;;
  esac
}
