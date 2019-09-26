FROM debian:buster-slim

RUN apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y \
        gnupg \
        ca-certificates \
        wget \
    && wget -O - https://qgis.org/downloads/qgis-2019.gpg.key | gpg --import \
    && gpg --export --armor 8D5A5B203548E5004487DD1951F523511C7028C3 | apt-key add - \
    && echo "deb http://qgis.org/debian buster main" >> /etc/apt/sources.list.d/qgis.list \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y \
        multiwatch \
        qgis-server \
        spawn-fcgi \
        xauth \
        xvfb \
    && apt-get remove --purge -y \
        gnupg \
        wget \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m qgis

ENV TINI_VERSION v0.17.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

ENV NGINX_VERSION   1.16.1
ENV NJS_VERSION     0.3.5
ENV PKG_RELEASE     1~buster
run apt-get update && apt-get install -y nginx

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

COPY nginx.conf /etc/nginx/sites-enabled/default

ENV QGIS_PREFIX_PATH /usr
ENV QGIS_SERVER_LOG_STDERR 1
ENV QGIS_SERVER_LOG_LEVEL 2
ENV QGIS_PROJECT_FILE /home/qgis/clever.qgs
ENV QGIS_DEBUG=5

ENV PROCESSES 1

COPY cmd.sh /home/qgis/cmd.sh
RUN chown qgis:qgis /home/qgis/cmd.sh

RUN apt-get update && apt-get install -y procps curl net-tools vim-tiny

WORKDIR /home/qgis

EXPOSE 8080

STOPSIGNAL SIGTERM

COPY clever.qgs /home/qgis/clever.qgs
RUN chown qgis:qgis /home/qgis/clever.qgs
CMD ["/home/qgis/cmd.sh"]
