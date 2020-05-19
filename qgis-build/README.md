# qgis-build

This directory contains a Dockerfile for building the `qgis-build` Docker image, which includes all
the tools and libraries necessary for building QGIS from source.

## Build the image

Clone the Git repo and change to the `qgis-build` directory:

```bash
git clone https://github.com/Oslandia/docker-qgis
cd docker-qgis/qgis-build
```

Build the `qgis-build` Docker image:

```bash
docker build -t qgis-build .
```

## Build QGIS

### Prerequisite

Create a `build` directory and place the QGIS source tree in that directory. Do not create it under
the `qgis-build` directory (or under a sub-directory of `qgis-build`), otherwise the QGIS source
tree will be part of the Docker context and building the image again will take a lot of time.

```bash
mkdir build
cd build
git clone https://github.com/qgis/QGIS.git
```

Create a directory `.ccache` in your home dir if you don't have one already:

```bash
mkdir $HOME/.ccache
```

### Build QGis server packages

```bash
docker run -it --rm -v $(pwd):/qgis -v $HOME/.ccache:/.ccache \
  -e USER=$(id -u):$(id -g) -e CCACHE_DIR=/.ccache qgis-build
```

Note that the `docker run` command should be run from the `build` directory, that is the directory
that contains the `QGIS` repository.

Notes:
* `-v $(pwd):/qgis` is used to mount the current directory (`build`) into `/qgis` in the container
* `-v $HOME/.ccache:/.ccache` is used to mount the user's ccache directory into `/.ccache` in the container
* `-e USER=$(id -u):$(id -g)` is used te set the `USER` envvar to `<user>:<group>` where `<user>` and `<group>` are the user id and group id of the current user (the one executing the `docker run` command), respectively. This variable is used to change the owner (using `chown`) of the generated .deb files
* `-e CCACHE_DIR=/.ccache` is used to set the `CCACHE_DIR` envvar to `/.ccache` for the compilation

By default, when running `docker run qgis-build`, the image's `/build-deb.sh` script is executed.
That script uses the `dch` and `dpkg-buildpackage` commands to build Debian packages for QGIS.

After the build completes you should find Debian packages (`.deb` files) in the `build` directory.

### Build QGis server application

If you just want to compile QGIS and don't want Debian packages you can change the command at
`docker run` time and use `bash` instead of the default `/build-deb.sh` script:

```bash
docker run -it --rm -v $(pwd):/qgis -v $HOME/.ccache:/.ccache \
    -e USER=$(id -u):$(id -g) -e CCACHE_DIR=/.ccache qgis-build bash
```

At this point you can execute the images's `/build.sh` script for building and installing QGIS using
`cmake` and `make`. Or you can execute the build commands of your choice.

After the compilation phase `/build.sh` installs QGIS under `/qgis/install`. So if the directory
`/qgis` is the target of a bind-mount (as in the sample command provided above) then QGIS will be
installed in a host directory that will still be there after the removal of the container. The
installation directory may be changed by setting the `INSTALL_PREFIX` environment variable.

The environment variable `BUILD_TYPE` may also be set. If not explicitely set the build type
defaults to `Release`. When set to `Debug` the resulting compilation artifacts will include debug
information.

## Running and debugging QGIS Server

After a sucessful compilation and installation of QGIS (in `/qgis/install`) a new `qgis-build`
container can be created for debugging QGIS Server.

For example:

```bash
docker run -it --rm -v $(pwd):/qgis v $HOME/qgis-data:/data \
  -u 0 -e LD_LIBRARY_PATH=/qgis/install/lib --network host \
  --cap-add=SYS_PTRACE --security-opt seccomp=unconfined qgis-build bash
```

Notes:
* in this example `$HOME/qgis-data/` is where a QGIS project is located on the host machine
* `LD_LIBRARY_PATH` is set to indicate where the QGIS libs are located
* `--network host` is used for QGIS to be able to access a database system running on the host machine
* `--cap-add=SYS_PTRACE` and `--security-opt seccomp=unconfined` are required for executing `gdb`

To execute QGIS Server 

* with `spawn-fcgi`:

  ```bash
  export QGIS_PROJECT_FILE=/data/eleonore.qgs
  /usr/bin/xvfb-run --auto-servernum --server-num=1 /usr/bin/spawn-fcgi \
    -p 5555 -n -d /root -- \
    /qgis/install/bin/qgis_mapserv.fcgi
  ```

* with `gdb`:

  ```bash
  /usr/bin/xvfb-run --auto-servernum --server-num=5 gdb \
    /qgis/install/bin/qgis_mapserv.fcgi
  ```

  gdb commands: 
  ```bash
  handle SIG33 nostop noprint pass
  set env QGIS_PROJECT_FILE=/data/eleonore.qgs
  set env QUERY_STRING=SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities
  run
  break src/server/qgis_map_serv.cpp:main
  run
  ```

  The `handle SIG33 nostop noprint pass` command is related to some issue in `gdb`. See https://bugzilla.redhat.com/show_bug.cgi?id=162402 for example.

## Option: Oracle provider compilation

If you want to generate .deb files for QGIS with support for the Oracle provider, you have to copy the following RPM provided by Oracle into
your `build` directory created before:
* oracle-instantclient12.1-basiclite-12.1.0.2.0-1.x86_64.rpm
* oracle-instantclient12.1-devel-12.1.0.2.0-1.x86_64.rpm

These RPM files can be obtained [from Oracle](https://www.oracle.com/technetwork/database/database-technologies/instant-client/downloads/index.html) by accepting their license agreement.

An environment variable `BUILD_ORACLE_PROVIDER` set to `y` will trigger the compilation and packaging of QGIS with an additional package for the Oracle provider:
```bash
docker run -it --rm -v $(pwd):/qgis -v $HOME/.ccache:/.ccache \
  -e USER=$(id -u):$(id -g) -e CCACHE_DIR=/.ccache \
  -e BUILD_ORACLE_PROVIDER=y qgis-build
```

## Known issues

Some utilities from Qt uses the `statx` syscall that needs the container to have some special privileges. This privileges may be present if your host has a `libseccomp` >= 2.3.3.

See the discussion in the [corresponding Docker PR](https://github.com/moby/moby/pull/36417)

For hosts with a version of `libseccomp` older than 2.3.3, a known workaround is to run docker commands in privileged mode by adding `--privileged` on the command line.

