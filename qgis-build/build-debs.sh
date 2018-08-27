#!/usr/bin/env bash

set -e

cd /qgis/QGIS
dch -l ~${DIST} --force-distribution --distribution ${DIST} "${DIST} build"
DEB_BUILD_OPTIONS=nocheck dpkg-buildpackage -us -uc -b --pre-clean --post-clean

exit 0
