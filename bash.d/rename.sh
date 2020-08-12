#!/usr/bin/env bash

# GLOBALS
arr=()
counter=0
findDir='.'
newName=''
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
        --dir|-d)   shift; findDir="$1"                                       ;;
        --suf|-s)   shift; suffix="$1"                                        ;;
        --pre|-p)   shift; prefix="$1"                                        ;;
        --rev|-r)   sortType='gr'                                             ;;
        --help|-h)  echo -e "$helpMsg"; exit 2                                ;;
        *)          echo -e "Invalid parameter '$1'\nEnter --help|-h"; exit 2 ;;
    esac
    shift
done

# MAIN
if [ ! -d "$findDir" ]; then
    echo "Cannot stat '$findDir': No such directory"
    exit 2
else
    findDir=$(realpath "$findDir")
fi

# while read line; do
#     (( counter++ ))
#     arr=($line)
#     newName=$(printf "%s_%s_%03d%s\n" $prefix ${arr[1]} $counter $suffix)
#     echo ${arr[0]} $findDir/$newName
# done < <(
#     find                            \
#         "$findDir"                  \
#         -type f                     \
#         -iname "*$suffix"           \
#         -printf "%p %CY-%Cm-%Cd\n"  \
#     | sort -"$sortType"             \
# )

findList=$(                             \
    find                                \
        "$findDir"                      \
        -type f                         \
        -iname "*$suffix"               \
        -printf "%p;%CY-%Cm-%Cd\n"      \
    | sort -g                           \
    | awk -F';' '{print $0 ";" NR}'     \
)

# if [ $counter -lt 1 ]; then
#     echo "No '*.$suffix' files in '$findDir'"
# fi