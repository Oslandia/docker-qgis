#!/usr/bin/env bash

set -e

xvfb-run spawn-fcgi -s /var/run/qgis.sock /usr/lib/cgi-bin/qgis_mapserv.fcgi

exec /usr/sbin/nginx -g "daemon off;"
