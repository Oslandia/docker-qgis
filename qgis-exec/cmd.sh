#!/bin/bash

[[ $DEBUG == "1" ]] && env

if [[ -n $PROCESSES && $PROCESSES -gt 1 ]]; then
    MULTIWATCH="/usr/bin/multiwatch -f $PROCESSES --"
else
    MULTIWATCH=""
fi

exec /usr/bin/xvfb-run --auto-servernum --server-num=1 /usr/sbin/fcgiwrap -s tcp:0.0.0.0:5555
