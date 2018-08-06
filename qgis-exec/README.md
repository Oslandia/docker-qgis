# qgis-exec

This directory contains a Dockerfile and other files for building the `qgis-exec` Docker image,
which includes all the software necessary for running QGIS Server.

## Build the image

First of all clone the Git repo and change to the `qgis-exec` directory:

```shell
$ git clone https://github.com/Oslandia/docker-qgis
$ cd docker-qgis/qgis-exec
```

The `qgis-exec` directory actually includes two Dockerfiles: `Dockerfile` and `Dockerfile-official`.
With `Dockerfile-official` official QGIS packages from http://qgis.org/debian/ are used.  With
`Dockerfile` local packages (generated using a `qgis-build` container) are used.

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

## Run NGINX and QGIS Server

The `qgis-exec` image includes QGIS Server and the `spwan-fcgi` program for running it. It doesn't
include a web server. This means that in addition to a `qgis-exec` container a web server should be
be run, and configured to forward requests to QGIS Server running in the `qgis-exec` container.

To that end this directory includes a Docker Compose file (`docker-compose.yml`) defining a complete
stack for running QGIS Server. That stack is composed of a `qgis-exec` container and an NGINX
container configured to work with `qgis-exec`.

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

## Without Docker Compose

If you just want to run a `qgis-exec` container you can use this:

```shell
$ docker run -d --name qgis-exec -v $(pwd)/data:/data:ro -e "QGIS_PROJECT_FILE=/data/osm.qgs" -e "PROCESSES=4" qgis-exec
```

And you can use `docker stop` and `docker rm` to stop and remove the container:

```shell
$ docker stop qgis-exec
$ docker rm qgis-exec
```

If the web server (NGINX) also runs in a container you will probably want to create a specific
Docker network for the web server and `qgis-exec` containers to be able to communicate :

```shell
$ docker network create qgis
```

And this is how you can make the `qgis-exec` container use that network:

```shell
$ docker run -d --name qgis-exec --network=qgis -v $(pwd)/data:/data:ro -e "QGIS_PROJECT_FILE=/data/osm.qgs" -e "PROCESSES=4" qgis-exec
```

## Query on the command line

For testing purposes it's possible to execute a query on the command line. This is done by setting
the `QUERY_STRING` environment variable for the execution of `qgis_mapserv.fcgi`.

For example:

```shell
$ docker run -it --rm -v $(pwd)/data:/data:ro -e "QGIS_PROJECT_FILE=/data/osm.qgs" -e "QUERY_STRING=SERVICE=WMS&REQUEST=GetCapabilities&VERSION=1.3.0" qgis-exec /usr/lib/cgi-bin/qgis_mapserv.fcgi
```

## Known issues/caveats

* On CentOS the containers may fail to start with a "Permission denied" errors. It is likely that
  the errors are related to SELinux. To fix it you can edit `docker-compose.yml` and change `:ro` to
  `:ro,Z` in the volume definitions.

## TODO

* Test the performance
