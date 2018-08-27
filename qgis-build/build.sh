#!/usr/bin/env bash

set -e

cd  /qgis/QGIS
mkdir -p build
cd build
cmake -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_VERBOSE_MAKEFILE=ON \
      -DWITH_SERVER=ON \
      -DWITH_SERVER_PLUGINS=ON \
      ..
make $@

exit 0
