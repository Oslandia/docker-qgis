#!/bin/bash

set -e

DIR=$(dirname $(readlink -f $0))
cd $DIR

docker build -t qgis-build .

cd ../qgis
docker run --rm -v $(pwd):/qgis -v $HOME/.ccache:/.ccache -u $(id -u):$(id -g) -e CCACHE_DIR=/.ccache qgis-build

exit 0
