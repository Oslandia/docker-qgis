#!/bin/bash

set -e

DIR=$(dirname $(readlink -f $0))
cd $DIR

mkdir -p deb
cp ../qgis/*.deb deb/

docker build -t qgis-exec .

exit 0
