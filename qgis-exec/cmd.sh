#!/bin/bash

error() {
    msg=shift
    echo $msg >&2
    exit 1
}

[[ $DEBUG == "1" ]] && env
[[ -n $PORT ]] || error "PORT is not defined"

exec /usr/bin/xvfb-run --auto-servernum --server-num=1 /usr/bin/spawn-fcgi -p $PORT -n -d /home/qgis -- /usr/lib/cgi-bin/qgis_mapserv.fcgi
