FROM madharjan/docker-nginx-onbuild:1.4.6
MAINTAINER Madhav Raj Maharjan <madhav.maharjan@gmail.com>

LABEL description="Docker container for Nginx with Web2py" os_version="Ubuntu 14.04"

ARG WEB2PY_VERSION
ARG WEB2PY_MIN=false
ARG DEBUG=false

ENV WEB2PY_VERSION ${WEB2PY_VERSION}
ENV WEB2PY_MIN ${WEB2PY_MIN}

RUN mkdir -p /build
COPY . /build

RUN /build/scripts/install.sh && /build/scripts/cleanup.sh

VOLUME ["/opt/web2py/applications", "/var/log/nginx"]

CMD ["/sbin/my_init"]

EXPOSE 80
