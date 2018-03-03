#!/usr/bin/env bash

source playchord.sh

source majorharm.sh
#source bluesharm.sh

degreeToChord() {
  local __degree=$1
  local __chord=$2
  for ((i=0 ; i < ${#degrees[@]} ; i++)); do
    [[ "${degrees[$i]}" == "$__degree" ]] && eval $__chord=${chords[$i]} && return
  done
  echo "Error could not find a chord for $__degree"
  exit 1
}

getNextDegree() {
  local __start=$1
  local __nextchord=$2
  local __nexts=()
  listNextDegrees "$__start" __nexts
  eval $__nextchord="${__nexts[$(($RANDOM % ${#__nexts[@]}))]}"
}

playsong() {
  local degree='I'
  local bar=2 # length of a bar in seconds
  local st=$(date +%s.%N)
  local __i=1
  while true; do
    getNextDegree $degree nextdegree
    degreeToChord $degree chord
    degreeToChord $nextdegree nextchord
    echo $degree $chord next: $nextdegree $nextchord
    local curr=$(date +%s.%N)
    # this is when you start having doubts about your choice of a language
    local barlength=$(bc -l <<< "$st + $__i "'*'" $bar - $curr")
    playnotes $chord 0.5 "$barlength"
    ((__i++))
    local degree=$nextdegree
  done
}

playsong

