FROM nginx:1.13

RUN apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y \
        psmisc \
        gnupg1 \
        ca-certificates \
    && apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 \
                   --keyserver-options timeout=10 \
                   --recv-keys 61E0A086749E463EDE502255CAEB3DC3BDF7FB45 \
    && echo "deb http://qgis.org/debian stretch main" >> /etc/apt/sources.list.d/qgis.list \
    && apt-get update \
    && apt-get install -y \
        psmisc \
        spawn-fcgi \
        qgis-server \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y \
        xauth \
        xvfb

ENV TINI_VERSION v0.17.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

COPY start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT ["/tini", "--"]
CMD ["/start.sh"]
