#!/usr/bin/env bash

# GLOBALS
findDir='.'
prefix='audiofile_'
suffix='.wav'
sortType='g'
creation=''
fileList=''
counter=0

# PARAMETERS
while (( "$#" )); do
    case "$1" in
        --dir|-d)   shift; findDir="$1"                     ;;
        --suf|-s)   shift; suffix="$1"                      ;;
        --pre|-p)   shift; prefix="$1"                      ;;
        --rev|-r)   sortType='gr'                           ;;
        *)          echo "Invalid parameter $1"; exit 2     ;;
    esac
    shift
done

# MAIN
if [ ! -d "$findDir" ]; then
    echo "Cannot stat '$findDir': No such directory"
    exit 2
fi

fileList=$(                         \
    find                            \
        "$findDir"                  \
        -type f                     \
        -iname "*$suffix"           \
        -printf "%p %CY-%Cm-%Cd\n"  \
    | sort -"$sortType"
)

for file in $fileList; do
    echo "$"
done

# stat -c %y $fileList | awk '{print $1}'
# printf "%03d\n" $counter
# (( counter++ ))

echo SUCCESS
