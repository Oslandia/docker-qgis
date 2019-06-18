#!/usr/bin/env bash

set -e

BUILD_TYPE=${BUILD_TYPE:-Release}

ROOT="/qgis"
QGIS="${ROOT}/QGIS"
BUILD="${QGIS}/build"
INSTALL="${ROOT}/install"

mkdir -p ${BUILD}
mkdir -p ${DIST}

cd ${BUILD}
cmake -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
      -DCMAKE_INSTALL_PREFIX=${INSTALL} \
      -DCMAKE_VERBOSE_MAKEFILE=ON \
      -DWITH_DESKTOP=OFF \
      -DWITH_SERVER=ON \
      -DWITH_SERVER_PLUGINS=ON \
      -DSERVER_SKIP_ECW=ON \
      -DSUPPRESS_QT_WARNINGS=ON \
      -DWITH_ASTYLE=OFF \
      -DWITH_APIDOC=OFF \
      -DENABLE_TESTS=ON \
      ${QGIS}
make $@
make install

exit 0
