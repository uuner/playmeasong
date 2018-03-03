#!/usr/bin/env bash

degrees=(I ii iii IV V vi vii)
chords=(C Dm Em F G Am Bdim)

listNextDegrees() {
  local __degree=$1
  local __next=$2
  case $__degree in
    I)
      eval $__next='("iii" "vi" "IV" "ii" "vii" "V")';;
    ii)
      eval $__next='("vii" "V" "I")';;
    iii)
      eval $__next='("vi" "IV")';;
    IV)
      eval $__next='("I" "ii" "vii" "V")';;
    V)
      eval $__next='("vi" "I")';;
    vi)
      eval $__next='("IV" "ii")';;
    vii)
      eval $__next='("I" "vi")';;
    *)
      echo Unrecognized chord $__degree
      exit 1;;
  esac
}
