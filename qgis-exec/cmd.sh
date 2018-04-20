#!/bin/bash

[[ $DEBUG == "1" ]] && env

exec /usr/bin/xvfb-run /usr/bin/spawn-fcgi -p 5555 -n -d /home/qgis -- /usr/bin/multiwatch -f $PROCESSES -- /usr/lib/cgi-bin/qgis_mapserv.fcgi
