# qgis-exec desktop

This directory contains a Dockerfile for building a Docker image for running
QGIS Desktop.

## Build the image for QGIS 3.X

Fist of all clone the Git repo and change to the `qgis-exec/desktop` directory:

```shell
$ git clone https://github.com/Oslandia/docker-qgis
$ cd docker-qgis/qgis-exec/desktop
```

Build the image:

```shell
$ docker build -f Dockerfile-official -t qgis-desktop .
```

## Run QGIS Desktop

```shell
$ ./qgis
```

## Build the image for QGIS 2.18

Fist of all clone the Git repo and change to the `qgis-exec/desktop` directory:

```shell
$ git clone https://github.com/Oslandia/docker-qgis
$ cd docker-qgis/qgis-exec/desktop
```

Build the image:

```shell
$ docker build -f Dockerfile-2-18 -t qgis-desktop-2-18 .
```

## Run QGIS Desktop

```shell
$ ./qgis-2-18
```
