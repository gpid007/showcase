#!/usr/bin/env bash

# GLOBALS
findDir='.'
printfStr=''
prefix='audiofile'
sortType='g'
suffix='.wav'
helpMsg='
INPUT PARAMETERS
    --dir | -d  ==  target directory    eg.     -d .
    --suf | -s  ==  target suffix       eg.     -s wav
    --pre | -p  ==  target prefix       eg.     -p audiofile
    --rev | -r  ==  reverse sorting     eg.     -r [leave empty]
EXAMPLE
    ./rename.sh -d pathToDir -r -p ABBA
'

# PARAMETERS
while (( "$#" )); do
    case "$1" in
        --dir|-d)   shift; findDir="$1"                                 ;;
        --suf|-s)   shift; suffix="$1"                                  ;;
        --pre|-p)   shift; prefix="$1"                                  ;;
        --rev|-r)   sortType='gr'                                       ;;
        --help|-h)  echo -e "$helpMsg";                      exit 2     ;;
        *)          echo -e "'$1' invalid\nEnter --help|-h"; exit 2     ;;
    esac
    shift
done

# MAIN
if [ ! -d "$findDir" ]; then
    echo "Cannot stat '$findDir': No such directory"
    exit 2
else
    cd "$findDir"
    printfStr="'%s' ${findDir}/${prefix}_%s_%03d${suffix}\n"
fi

find "$findDir" -type f -name "*$suffix" -printf "%p;%CY-%Cm-%Cd\n"     \
| sort -"$sortType"                                                     \
| awk -F';' '{print $0 ";" NR}'                                         \
| awk -F';' "{printf \"$printfStr\", \$1,\$2,\$3}"                      \
| while read line; do
    echo "mv $line"
    eval "mv $line"
done

# CREATE DUMMY FILES
# touch 'a a.wav' b.wav c.wav 'd d.wav'