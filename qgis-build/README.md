# qgis-build

This directory includes a Dockerfile for building the `qgis-build` Docker image, which includes
all the tools and libraries necessary for building QGIS from source.

## Build the image

Clone the Git repo and change to the `qgis-build` directory:

```shell
$ git clone ssh://git@git.oslandia.net:10022/Client-projects/docker-qgis.git
$ cd docker-qgis/qgis-build
```

Build the `qgis-build` Docker image:

```shell
$ docker build -t qgis-build .
```

## Build QGIS

Create a `build` directory and place the QGIS source tree in that directory. Do not create it under
the `qgis-build` directory (or under a sub-directory of `qgis-build`), otherwise the QGIS source
tree will be part of the Docker context and building the image again will take a lot of time.

```shell
$ mkdir build
$ cd build
$ git clone https://github.com/qgis/QGIS.git
```

Build QGIS:

```shell
$ docker run -it --rm -v $(pwd):/qgis qgis-build
```

Note that the `docker run` command should be run from the `build` directory, that is the directory
that contains the `QGIS` repository.

After the build completes you should find Debian packages (`.deb` files) in the `build` directory.
