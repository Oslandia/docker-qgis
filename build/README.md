# qgis-build

The `qgis-build` Docker image includes all the tools and libraries necessary for building QGIS.

## Build the image

```shell
$ docker build -t qgis-build .
```

## Build QGIS

Create a build directory and place the QGIS source tree in that directory:

```shell
$ mkdir build
$ cd build
$ git clone https://github.com/qgis/QGIS.git
```

Build QGIS:

```shell
$ docker run -it --rm -v $(pwd):/qgis qgis-build
```

The build process creates Debian packages in the `build` directory.
