#!/usr/bin/env bash

# --pre-clean
# --post-clean

set -e

cd /qgis

if [[ "${BUILD_ORACLE_PROVIDER}" = "y" ]]; then
    [ -e oracle-instantclient12.1-basiclite*.deb ] || alien -d oracle-instantclient12.1-basiclite*.rpm
    [ -e oracle-instantclient12.1-devel*.deb ] || alien -d oracle-instantclient12.1-devel*.rpm
    dpkg -i oracle-instantclient12.1-basiclite*.deb
    dpkg -i oracle-instantclient12.1-devel*.deb
    DIST="${DIST}-oracle"
fi

export DEB_BUILD_OPTIONS="${DEB_BUILD_OPTIONS} nocheck"  # for dpkg-buildpackage

cd /qgis/QGIS
dch -l ~${DIST} --force-distribution --distribution ${DIST} "${DIST} build"
dpkg-buildpackage -us -uc -b $@
if [[ -n "$USER" ]]; then
    chown $USER /qgis/oracle-*deb /qgis/qgis*deb /qgis/libqgis*deb /qgis/qgis*buildinfo /qgis/qgis*changes /qgis/python*deb
fi
exit 0
