# qgis-exec

This directory includes a Dockerfile and other files for building the `qgis-exec` Docker image,
which includes all the software necessary for running QGIS Server.

## Build the image

There are actually two Dockerfiles: `Dockerfile` and `Dockerfile-official`. When
`Dockerfile-official` is used the official QGIS packages from `http://qgis.org/debian/` are used.
When using `Dockerfile` local packages (generated using a `qgis-build` container) are used.

Build the image using official QGIS packages:

```shell
$ docker build -f Dockerfile-official -t qgis-exec .
```

To build the image using local packages requires copying the packages (the `.deb` files) to a `deb`
directory located in this directory:

```shell
$ mkdir -p deb
$ cp /path/to/debs/*.deb deb/
```

The required packages are:

- libqgis-analysis
- libqgis-app
- libqgis-core
- libqgis-customwidgets
- libqgisgrass7
- libqgis-gui
- libqgis-native
- libqgispython
- libqgis-server
- python-qgis
- qgis-common
- qgis-providers
- qgis-server

Build the image using local packages:

```shell
$ docker build -t qgis-exec .
```

## Run QGIS Server

The `qgis-exec` image includes QGIS Server and the `spwan-fcgi` program for running it. It doesn't
include a web server. This means that in addition to a `qgis-exec` container a web server should be
be run (and configured to forward requests to QGIS Server running in the `qgis-exec` container).

To that end this directory includes a `docker-compose.yml` defining a complete stack for running
QGIS Server. That stack is composed of a `qgis-exec` container and an NGINX container properly
configured.

Start the stack:

```shell
$ docker-compose up
```

If `docker-compose` is not available on your system you can install it using in a Python
virtual environment:

```shell
$ virtualenv venv
(venv) $ pip install docker-compose
```

When the stack is up you can open http://localhost:8080 in your browser. You should see
an OpenLayers map connected to the osm.qgs QGIS project used as an example.

Stop the stack:

```shell
$ docker-compose rm -sf
```
