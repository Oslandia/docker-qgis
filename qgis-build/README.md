# qgis-build

This directory contains a Dockerfile for building the `qgis-build` Docker image, which includes all
the tools and libraries necessary for building QGIS from source.

## Build the image

Clone the Git repo and change to the `qgis-build` directory:

```shell
$ git clone https://github.com/Oslandia/docker-qgis
$ cd docker-qgis/qgis-build
```

Build the `qgis-build` Docker image:

```shell
$ docker build -t qgis-build .
```

## Clone QGIS repo

Create a `build` directory and place the QGIS source tree in that directory. Do not create it under
the `qgis-build` directory (or under a sub-directory of `qgis-build`), otherwise the QGIS source
tree will be part of the Docker context and building the image again will take a lot of time.

```shell
$ mkdir build
$ cd build
$ git clone https://github.com/qgis/QGIS.git
```

## Build QGIS Debian packages

```shell
$ cd build
$ docker run -it --rm -v $(pwd):/qgis -u $(id -u):$(id -g) qgis-build
```

Note that the `docker run` command should be run from the `build` directory, that is the directory
that contains the `QGIS` repository.

Notes:

* `-v $(pwd):/qgis` is used to mount the current directory (`build`) into `/qgis` in the container
* `-u $(id -u):$(id -g)` is used to use the local user id and group id within the container

After the build completes you should find Debian packages (`.deb` files) in the `build` directory.

## Build QGIS

Alternatively you can build QGIS without creating Debian packages.

To build QGIS requires a cache directory for `ccache`:

```shell
$ mkdir -p $HOME/.ccache
```

Build QGIS:

```shell
$ cd build
$ docker run -it --rm -v $(pwd):/qgis -v $HOME/.ccache:/.ccache -e PROCESSES=4 -u $(id -u):$(id -g) qgis-build /build.sh
```

Notes :

* With this command the shell script `/build.sh` is invoked, while `/build-deb.sh` is invoked by
  default (when no extra parameter is passed to the `docker run` command)
* `-v $HOME/.ccache:/.ccache` is used to mount the user's `ccache` directory into `/.ccache` in the
  container
* `PROCESSES=4` means use four processes for the build of QGIS. Just one process will be used if
  `PROCESSES` is not set.
