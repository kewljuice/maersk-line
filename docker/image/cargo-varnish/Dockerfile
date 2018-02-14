# Set the base image to PHP
FROM alpine:3.6

# File Maintainer
MAINTAINER ctrl.be

# Install Dependencies
ENV VARNISH_MEMORY 100M
ENV VARNISH_HTTP_PORT 80
ENV VARNISH_HTTP_ADMIN_PORT 81
ENV VARNISH_ADMIN_PORT 6082

RUN \
    apk update && \
    apk add 'varnish<4.2' tzdata && \
    cp /usr/share/zoneinfo/Europe/Brussels /etc/localtime && \
    echo "Europe/Brussels" >  /etc/timezone && \
    apk del tzdata && \
    rm -rf /var/cache/apk/*

EXPOSE 80 81 6082

COPY ./entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]

# That's all folks