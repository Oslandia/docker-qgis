# Docker QGIS

This repo includes two directories: `build` and `exec`.

`build` includes materials for creating a `qgis-build` Docker image that can be used for building
QGIS in a Docker container.

`exec` includes materials for creating a `qgis-exec` Docker image that can be used to execute QGIS
Server in a Docker container.

The creation of the `qgis-exec` image can be based on QGIS packages generated using a `qgis-build`
container.
