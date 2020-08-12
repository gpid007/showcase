#!/usr/bin/env bash

if [[ "$1" == '' ]]; then
    targetIP='18.184.102.241'
else
    targetIP="$1"
fi

ansible-playbook -i "$targetIP", postgres-play.yml
