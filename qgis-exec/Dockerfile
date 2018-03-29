FROM debian:stretch-slim

COPY deb/libqgis-analysis*.deb \
     deb/libqgis-app*.deb \
     deb/libqgis-core*.deb \
     deb/libqgis-customwidgets*.deb \
     deb/libqgisgrass7*.deb \
     deb/libqgis-gui*.deb \
     deb/libqgis-native*.deb \
     deb/libqgispython*.deb \
     deb/libqgis-server*.deb \
     deb/python-qgis*.deb \
     deb/qgis-common*.deb \
     deb/qgis-providers*.deb \
     deb/qgis-server*.deb \
     /qgis/

RUN apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y \
        multiwatch \
        spawn-fcgi \
        xauth \
        xvfb \
    && apt install --no-install-recommends --no-install-suggests -y /qgis/*.deb \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m qgis

ENV TINI_VERSION v0.17.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

ENV QGIS_PREFIX_PATH /usr
ENV QGIS_SERVER_LOG_FILE /var/log/qgisserver.log
ENV QGIS_SERVER_LOG_LEVEL 0
ENV QGIS_DEBUG 1

ENV PROCESSES 1

USER qgis
WORKDIR /home/qgis

ENTRYPOINT ["/tini", "--"]

CMD ["sh", "-c", "xvfb-run spawn-fcgi -p 5555 -n -d /home/qgis -- /usr/bin/multiwatch -f $PROCESSES -- /usr/lib/cgi-bin/qgis_mapserv.fcgi"]
