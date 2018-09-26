#!/bin/bash

set -e

DIR=$(dirname $(readlink -f $0))
cd $DIR

docker build -f Dockerfile-official -f Dockerfile-official -t qgis-exec .

exit 0
