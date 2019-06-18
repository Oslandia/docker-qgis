FROM debian:buster-slim

RUN apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y \
        alien \
        bison \
        build-essential \
        ca-certificates \
        ccache \
        cmake \
        cmake-curses-gui \
        debhelper \
        devscripts \
        dh-python \
        doxygen \
        expect \
        flex \
        gdal-bin \
        gdb \
        git \
        graphviz \
        grass-dev \
        libdistro-info-perl \
        libexiv2-dev \
        libexpat1-dev \
        libfcgi-dev \
        libgdal-dev \
        libgeos-dev \
        libgsl-dev \
        libosgearth-dev \
        libpq-dev \
        libproj-dev \
        libqca-qt5-2-dev \
        libqca-qt5-2-plugins \
        libqt5opengl5-dev \
        libqt5scintilla2-dev \
        libqt5serialport5-dev \
        libqt5sql5-sqlite \
        libqt5svg5-dev \
        libqt5webkit5-dev \
        libqt5xmlpatterns5-dev \
        libqwt-qt5-dev \
        libspatialindex-dev \
        libspatialite-dev \
        libsqlite3-dev \
        libsqlite3-mod-spatialite \
        libzip-dev \
        lighttpd \
        locales \
        ninja-build \
        ocl-icd-opencl-dev \
        opencl-headers \
        pkg-config \
        poppler-utils \
        pyqt5-dev \
        pyqt5-dev-tools \
        pyqt5.qsci-dev \
        python3-all-dev \
        python3-dateutil \
        python3-dev \
        python3-future \
        python3-gdal \
        python3-httplib2 \
        python3-jinja2 \
        python3-markupsafe \
        python3-mock \
        python3-nose2 \
        python3-owslib \
        python3-plotly \
        python3-psycopg2 \
        python3-pygments \
        python3-pyproj \
        python3-pyqt5 \
        python3-pyqt5.qsci \
        python3-pyqt5.qtsql \
        python3-pyqt5.qtsvg \
        python3-requests \
        python3-sip \
        python3-sip-dev \
        python3-six \
        python3-termcolor \
        python3-tz \
        python3-yaml \
        qt5-default \
        qt5keychain-dev \
        qtbase5-dev \
        qtbase5-private-dev \
        qtpositioning5-dev \
        qttools5-dev \
        qttools5-dev-tools \
        qt3d5-dev \
        qt3d-assimpsceneimport-plugin \
        qt3d-defaultgeometryloader-plugin \
        qt3d-gltfsceneio-plugin \
        qt3d-scene2d-plugin \
        saga \
        spawn-fcgi \
        txt2tags \
        xauth \
        xfonts-100dpi \
        xfonts-75dpi \
        xfonts-base \
        xfonts-scalable \
        xvfb \
    && rm -rf /var/lib/apt/lists/*

# Add tini. This is to be able, after compilation, to use the build container as a
# container for executing QGIS Server
ENV TINI_VERSION v0.17.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

COPY build.sh build-debs.sh /
RUN chmod a+x /build.sh /build-debs.sh

ENV DIST buster

WORKDIR /qgis/QGIS

CMD ["/build-debs.sh"]
