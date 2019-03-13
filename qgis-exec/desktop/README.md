# qgis-exec desktop

This directory contains a Dockerfile for building a Docker image for running
QGIS Desktop.

## Build the image

Fist of all clone the Git repo and change to the `qgis-exec/desktop` directory:

```shell
$ git clone https://github.com/Oslandia/docker-qgis
$ cd docker-qgis/docker-exec/desktop
```

Build the image:

```shell
$ docker build -f Dockerfile-official -t qgis-desktop .
```

## Run QGIS Desktop

```shell
$ ./qgis
```
