# docker-nginx-web2py

[![Build Status](https://travis-ci.com/madharjan/docker-nginx-web2py.svg?branch=master)](https://travis-ci.com/madharjan/docker-nginx-web2py)
[![Layers](https://images.microbadger.com/badges/image/madharjan/docker-nginx-web2py.svg)](http://microbadger.com/images/madharjan/docker-nginx-web2py)

Docker container for Nginx with Web2py based on [madharjan/docker-nginx](https://github.com/madharjan/docker-nginx/)

## Features

* Environment variables to set admin password
* Minimal (for production deploy) version of container `docker-nginx-web2py-min` for Web2py without `admin`, `example` and `welcome`
* Bats [bats-core/bats-core](https://github.com/bats-core/bats-core) based test cases

## Nginx 1.10.3 & Web2py 2.18.3 (docker-nginx-web2py)

### Environment

| Variable             | Default | Example        |
|----------------------|---------|----------------|
| WEB2PY_ADMIN         |         | Pa55w0rd       |
| DISABLE_UWSGI        | 0       | 1 (to disable) |
|                      |         |                                                                  |
| INSTALL_PROJECT      | 0       | 1 (to enable)                                                    |
| PROJECT_GIT_REPO     |         | https://github.com/BlackrockDigital/startbootstrap-creative.git  |
| PROJECT_GIT_TAG      | HEAD    | v5.1.4                                                           |

## Build

```bash
# clone project
git clone https://github.com/madharjan/docker-nginx-web2py
cd docker-nginx-web2py

# build
make

# tests
make run
make test

# clean
make clean
```

## Run

```bash
# prepare foldor on host for container volumes
sudo mkdir -p /opt/docker/web2py/applications/
sudo mkdir -p /opt/docker/web2py/log/

docker stop web2py
docker rm web2py

# run container
# Web2py include Admin, Example and Welcome
docker run -d \
  -e WEB2PY_ADMIN=Pa55word \
  -p 80:80 \
  -v /opt/docker/web2py/applications:/opt/web2py/applications \
  -v /opt/docker/web2py/log:/var/log/nginx \
  --name web2py \
  madharjan/docker-nginx-web2py:2.18.5

# run container
# Web2py Minimal
docker run -d \
  -e WEB2PY_ADMIN=Pa55word \
  -p 80:80 \
  -v /opt/docker/web2py/applications:/opt/web2py/applications \
  -v /opt/docker/web2py/log:/var/log/nginx \
  --name web2py \
  madharjan/docker-nginx-web2py-min:2.18.5
```

## Systemd Unit File

**Note**: update environment variables below as necessary

```txt
[Unit]
Description=Web2py Framework

After=docker.service

[Service]
TimeoutStartSec=0

ExecStartPre=-/bin/mkdir -p /opt/docker/web2py/applications
ExecStartPre=-/bin/mkdir -p /opt/docker/web2py/log
ExecStartPre=-/usr/bin/docker stop web2py
ExecStartPre=-/usr/bin/docker rm web2py
ExecStartPre=-/usr/bin/docker pull madharjan/docker-nginx-web2py:2.18.5

ExecStart=/usr/bin/docker run \
  -e WEB2PY_ADMIN=Pa55w0rd \
  -p 80:80 \
  -v /opt/docker/web2py/applications:/opt/web2py/applications \
  -v /opt/docker/web2py/log:/var/log/nginx \
  --name  web2py \
  madharjan/docker-nginx-web2py:2.18.5

ExecStop=/usr/bin/docker stop -t 2 web2py

[Install]
WantedBy=multi-user.target
```

## Generate Systemd Unit File

| Variable             | Default          | Example                                                          |
|----------------------|------------------|------------------------------------------------------------------|
| PORT                 |                  | 8080                                                             |
| VOLUME_HOME          | /opt/docker      | /opt/data                                                        |
| NAME                 | ngnix            |                                                                  |
|                      |                  |                                                                  |
| WEB2PY_ADMIN         |                  | Pa55w0rd                                                         |
| WEB2PY_MIN           | true             | false                                                            |
|                      |                  |                                                                  |
| INSTALL_PROJECT      | 0                | 1 (to enable)                                                    |
| PROJECT_GIT_REPO     |                  | [https://github.com/madharjan/web2py-contest](https://github.com/madharjan/web2py-contest)                                                           |
| PROJECT_GIT_TAG      | HEAD             | v1.0                                                             |

### With deploy web projects

```bash
docker run --rm \
  -e PORT=80 \
  -e VOLUME_HOME=/opt/docker \
  -e VERSION=2.18.5 \
  -e WEB2PY_ADMIN=Pa55w0rd \
  -e WEB2PY_MIN=false \
  -e INSTALL_PROJECT=1 \
  -e PROJECT_GIT_REPO=https://github.com/madharjan/web2py-contest.git \
  -e PROJECT_GIT_TAG=HEAD \
  madharjan/docker-nginx-web2py-min:2.18.5 \
  web2py-systemd-unit | \
  sudo tee /etc/systemd/system/web2py.service

sudo systemctl enable web2py
sudo systemctl start web2py
```
