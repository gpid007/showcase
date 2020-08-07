#!/usr/bin/env bash

# GLOBAL DEFAULTS
findDir='.'
prefix='audiofile_'
suffix='.wav'
creation=''
counter=0

# PARAMETERS
while ("$#"); do
    case "$1" in
        --dir|-d)   findDir="$1"                                ;;
        --suf|-s)   suffix="$1"                                 ;;
        --pre|-p)   prefix="$1"                                 ;;
        *)          echo "Please enter valid parameter flag."   ;;
    esac
    shift
done


if [ ! -d "$findDir" ]; then
    echo "Cannot stat '$findDir': No such directory"
    return 2
fi

# find                    \
#     "$findDir"          \
#     -type f             \
#     -iname "*$suffix"
# stat -c %y $filePath | awk '{print $1}'
# printf "%03d\n" $counter
# (( counter++ ))