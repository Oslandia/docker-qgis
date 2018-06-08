#!/bin/bash

[[ $DEBUG == "1" ]] && env

if [[ -n $PROCESSES && $PROCESSES -gt 1 ]]; then
    MULTIWATCH="/usr/bin/multiwatch -f $PROCESSES --"
else
    MULTIWATCH=""
fi

exec /usr/bin/xvfb-run /usr/bin/spawn-fcgi -p 5555 -n -d /home/qgis -- $MULTIWATCH /usr/lib/cgi-bin/qgis_mapserv.fcgi
