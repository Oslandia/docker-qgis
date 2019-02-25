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

## Build QGIS

Create a `build` directory and place the QGIS source tree in that directory. Do not create it under
the `qgis-build` directory (or under a sub-directory of `qgis-build`), otherwise the QGIS source
tree will be part of the Docker context and building the image again will take a lot of time.

```shell
$ mkdir build
$ cd build
$ git clone https://github.com/qgis/QGIS.git
```

Create a directory `.ccache` in your home dir if you don't have one already:

```shell
$ mkdir $HOME/.ccache
```

Build QGIS:

```shell
$ docker run -it --rm -v $(pwd):/qgis -v $HOME/.ccache:/.ccache -u $(id -u):$(id -g) -e CCACHE_DIR=/.ccache qgis-build
```

Note that the `docker run` command should be run from the `build` directory, that is the directory
that contains the `QGIS` repository.

Notes:

* `-v $(pwd):/qgis` is used to mount the current directory (`build`) into `/qgis` in the container
* `-v $HOME/.ccache:/.ccache` is used to mount the user's ccache directory into `/.ccache` in the container
* `-u $(id -u):$(id -g)` is used to use the local user id and group id within the container
* `-e CCACHE_DIR=/.ccache` is used to set the `CCACHE_DIR` envvar to `/.ccache` for the compilation

After the build completes you should find Debian packages (`.deb` files) in the `build` directory.

## Advanced

By default, when running `docker run qgis-build`, the image's `/build-deb.sh` script is executed.
That script uses the `dch` and `dpkg-buildpackage` commands to build Debian packages for QGIS.

If you just want to compile QGIS and don't want Debian packages you can change the command at
`docker run` time and use `bash` instead of the default `/build-deb.sh` script:

```shell
$ docker run -it --rm -v $(pwd):/qgis -v $HOME/.ccache:/.ccache -u $(id -u):$(id -g) -e CCACHE_DIR=/.ccache qgis-build bash
```

At this point you can execute the images's `/build.sh` script for building and installing QGIS using
`cmake` and `make`. Or you can execute the build commands of your choice.

After the compilation phase `/build.sh` installs QGIS into `/qgis/install`. So if the directory
`/qgis` is the target of a bind-mount (as in the sample command provided above) then QGIS will be
installed in a host directory that will still be there after the removal of the container.

Prior to executing `/build.sh` the environment variable `BUILD_TYPE` may be set. If not explicitely
set the build type defaults to `Release`. When set to `Debug` the resulting compilation artifacts
will include debug information.

### Debugging QGIS Server

After a sucessful compilation and installation of QGIS (in `/qgis/install`) a new `qgis-build`
container can be created for debugging QGIS Server.

For example:

```shell
$ docker run -it --rm -v $(pwd):/qgis v $HOME/qgis-data:/data -u 0 -e LD_LIBRARY_PATH=/qgis/install/lib --network host --cap-add=SYS_PTRACE --security-opt seccomp=unconfined qgis-build bash
```

* in this example `$HOME/qgis-data/` is where a QGIS project is located on the host machine
* `LD_LIBRARY_PATH` is set to indicate where the QGIS libs are located
* `--network host` is used for QGIS to be able to access a database system running on the host machine
* `--cap-add=SYS_PTRACE` and `--security-opt seccomp=unconfined` are required for executing `gdb`

Now to run QGIS Server with `gdb`:

```shell
# /usr/bin/xvfb-run --auto-servernum --server-num=5 gdb /qgis/install/bin/qgis_mapserv.fcgi
(gdb) handle SIG33 nostop noprint pass
(gdb) set env QGIS_PROJECT_FILE=/data/eleonore.qgs
(gdb) set env QUERY_STRING=SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities
(gdb) run
(gdb) break src/server/qgis_map_serv.cpp:main
(gdb) run
```

The `handle SIG33 nostop noprint pass` command is related to some issue in `gdb`. See https://bugzilla.redhat.com/show_bug.cgi?id=162402 for example.
