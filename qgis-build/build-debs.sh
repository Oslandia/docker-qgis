#!/usr/bin/env bash

# --pre-clean
# --post-clean

set -e

export DEB_BUILD_OPTIONS="${DEB_BUILD_OPTIONS} nocheck"  # for dpkg-buildpackage

cd /qgis/QGIS
dch -l ~${DIST} --force-distribution --distribution ${DIST} "${DIST} build"
dpkg-buildpackage -us -uc -b $@

exit 0
