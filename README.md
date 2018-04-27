# Docker QGIS

This repo provides two Docker images for QGIS: `qgis-build` and `qgis-exec`.

The `qgis-build` image is used for building QGIS from source. Debian packages of QGIS are created.

The `qgis-exec` image is used for executing QGIS Server. The image is built either from official
QGIS packages downloaded from http://qgis.org/debian or from local QGIS packages generated using the
`qgis-build` image.
