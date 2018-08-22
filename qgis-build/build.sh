#!/usr/bin/env bash

set -e

MAKE_OPTIONS=""
[[ -n $PROCESSES ]] && MAKE_OPTIONS="$MAKE_OPTIONS -j $PROCESSES"

cd  /qgis/QGIS
mkdir -p build
cd build
cmake ..
make $MAKE_OPTIONS

exit 0
