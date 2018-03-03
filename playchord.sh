#!/usr/bin/env bash

command -v sox >/dev/null 2>&1 || {
  # we are using "play" but checking for sox is more reliable
  echo >&2 "SoX (Sound eXchange) must be installed."
  exit 1
}

shopt -s extglob

single=(0)
major=(0 4 7)
minor=(0 3 7)
dim=(0 3 6)
major7=(0 4 7 11)
minor7=(0 3 7 10)
dim7=(0 3 6 9)
dominant7=(0 4 7 10)
major13=(0 4 7 11 14 21)
just5=(0 5)
sus4=(0 5 7)
sus2=(0 2 7)
just6=(0 4 7 9)
minmaj7=(0 3 7 11)
minor6=(0 3 7 9)
just9=(0 4 7 10 14)
minor9=(0 3 7 10 14)
major9=(0 4 7 11 14)
minmaj9=(0 3 7 11 14)
just11=(0 4 7 10 14 17)
min11=(0 3 7 10 14 17)
maj11=(0 4 7 11 14 17)
minmaj11=(0 3 7 11 14 17)
just13=(0 4 7 12 14 21)
min13=(0 3 7 12 14 21)
minmaj13=(0 3 7 11 14 21)
add9=(0 4 7 14)
minadd9=(0 3 7 14)
just6add9=(0 4 7 9 14)
min6add9=(0 3 7 9 14)
dom7add11=(0 4 7 10 17)
maj7add11=(0 4 7 11 17)
min7add11=(0 3 7 10 17)
minmaj7add11=(0 3 7 11 17)
dom7add13=(0 4 7 10 21)
maj7add13=(0 4 7 11 21)
min7add13=(0 3 7 10 21)
minmaj7add13=(0 3 7 11 21)
just7b5=(0 4 6 10 )
just7sh5=(0 4 8 10)
just7b9=(0 4 7 10 13)
just7sh9=(0 4 7 10 15)

playch() {
  local __base=$1
  local __delay=$2
  local __fadetruncate=$3
  local __notes=("${!4}")
  (for note in "${__notes[@]}"; do
     echo pl %$(($note+$__base))
   done
   echo delay
   local __del=0
   for note in "${__notes[@]}"; do
     echo $__del
     __del=$(echo "$__del+$__delay" | bc -q 2>/dev/null)
   done
   if [[ $__fadetruncate != "0" ]]; then
     fadelength=$__fadetruncate
   else
     fadelength="$(echo $__delay '*' ${#__notes[@]} | bc -l)"
   fi
   echo remix - fade 0 $fadelength 0 norm -1 vol 0.3
  ) | xargs play -q -n synth
}

notetobase() {
  local __note=$1
  local __resultvar=$2
  case $__note in
    A*)
      __base=0;;
    B*)
      __base=2;;
    C*)
      __base=-9;;
    D*)
      __base=-7;;
    E*)
      __base=-5;;
    F*)
      __base=-4;;
    G*)
      __base=-2;;
    *)
      echo Unrecognized note $__note
      exit 1;;
  esac
  if [[ $__note =~ ^[A-G]\# ]]; then
    __base=$(($__base+1))
  elif [[ $__note =~ ^[A-Z]b ]]; then
    __base=$(($__base-1))
  fi
  if [[ "$__resultvar" ]]; then
    eval $__resultvar="'$__base'"
  else
    echo "$__base"
  fi
}

chordtoarray() {
  local __name=$1
  local __resultvar=$2
  case $__name in
    [A-G]?([#b]))
      eval $__resultvar="major[@]";;
    [A-G]?([#b])m)
      eval $__resultvar="minor[@]";;
    [A-G]?([#b])dim)
      eval $__resultvar="dim[@]";;
    [A-G]?([#b])maj7)
        eval $__resultvar="major7[@]";;
    [A-G]?([#b])m7)
        eval $__resultvar="minor7[@]";;
    [A-G]?([#b])dim7)
        eval $__resultvar="dim7[@]";;
    [A-G]?([#b])7)
        eval $__resultvar="dominant7[@]";;
    [A-G]?([#b])maj13)
        eval $__resultvar="major13[@]";;
    [A-G]?([#b])5)
        eval $__resultvar="just5[@]";;
    [A-G]?([#b])sus4)
        eval $__resultvar="sus4[@]";;
    [A-G]?([#b])sus2)
        eval $__resultvar="sus2[@]";;
    [A-G]?([#b])6)
        eval $__resultvar="just6[@]";;
    [A-G]?([#b])minmaj7)
        eval $__resultvar="minmaj7[@]";;
    [A-G]?([#b])m6)
        eval $__resultvar="minor6[@]";;
    [A-G]?([#b])9)
        eval $__resultvar="just9[@]";;
    [A-G]?([#b])min9)
        eval $__resultvar="minor9[@]";;
    [A-G]?([#b])maj9)
        eval $__resultvar="major9[@]";;
    [A-G]?([#b])minmaj9)
        eval $__resultvar="minmaj9[@]";;
    [A-G]?([#b])11)
        eval $__resultvar="just11[@]";;
    [A-G]?([#b])min11)
        eval $__resultvar="min11[@]";;
    [A-G]?([#b])maj11)
        eval $__resultvar="maj11[@]";;
    [A-G]?([#b])minmaj11)
        eval $__resultvar="minmaj11[@]";;
    [A-G]?([#b])13)
        eval $__resultvar="just13[@]";;
    [A-G]?([#b])m13)
        eval $__resultvar="min13[@]";;
    [A-G]?([#b])minmaj13)
        eval $__resultvar="minmaj13[@]";;
    [A-G]?([#b])add9)
        eval $__resultvar="add9[@]";;
    [A-G]?([#b])minadd9)
        eval $__resultvar="minadd9[@]";;
    [A-G]?([#b])6add9)
        eval $__resultvar="just6add9[@]";;
    [A-G]?([#b])min6add9)
        eval $__resultvar="min6add9[@]";;
    [A-G]?([#b])7add11)
        eval $__resultvar="dom7add11[@]";;
    [A-G]?([#b])maj7add11)
        eval $__resultvar="maj7add11[@]";;
    [A-G]?([#b])min7add11)
        eval $__resultvar="min7add11[@]";;
    [A-G]?([#b])minmaj7add11)
        eval $__resultvar="minmaj7add11[@]";;
    [A-G]?([#b])7add13)
        eval $__resultvar="dom7add13[@]";;
    [A-G]?([#b])maj7add13)
        eval $__resultvar="maj7add13[@]";;
    [A-G]?([#b])min7add13)
        eval $__resultvar="min7add13[@]";;
    [A-G]?([#b])minmaj7add13)
        eval $__resultvar="minmaj7add13[@]";;
    [A-G]?([#b])7b5)
        eval $__resultvar="just7b5[@]";;
    [A-G]?([#b])7#5)
        eval $__resultvar="just7sh5[@]";;
    [A-G]?([#b])7b9)
        eval $__resultvar="just7b9[@]";;
    [A-G]?([#b])7#9)
        eval $__resultvar="just7sh9[@]";;
    *)
      echo Unrecognized chord $__name
      exit 1;;
  esac
}

playnotes() {
  local __chord=$1
  local __delay=$2
  local __fadetruncate=$3
  notetobase $__chord __base
  chordtoarray $__chord __arr
  playch $__base $__delay $__fadetruncate $__arr
}

playchord() {
  playnotes $1 0.05 2
}

playarpeggio() {
  playnotes $1 0.5 0
}

if [ -z "$1" ]; then
  # TODO print usage here
  echo -n
else
  playchord $1
  #playarpeggio $1
fi
