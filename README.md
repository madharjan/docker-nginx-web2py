# docker-nginx-web2py

[![Build Status](https://travis-ci.com/madharjan/docker-nginx-web2py.svg?branch=master)](https://travis-ci.com/madharjan/docker-nginx)
[![Layers](https://images.microbadger.com/badges/image/madharjan/docker-nginx-web2py.svg)](http://microbadger.com/images/madharjan/docker-nginx)

Docker container for Nginx with Web2py based on [madharjan/docker-nginx](https://github.com/madharjan/docker-nginx/)

## Features

* Environment variables to set admin password
* Minimal (for production deploy) version of container `docker-nginx-web2py-min` for Web2py without `admin`, `example` and `welcome`
* Bats ([bats-core/bats-core](https://github.com/bats-core/bats-core)) based test cases

## Nginx 1.10.3 & Web2py 2.18.5 (docker-nginx-web2py)

### Environment

| Variable       | Default | Example        |
|----------------|---------|----------------|
| WEB2PY_ADMIN   |         | Pa55w0rd       |
| DISABLE_UWSGI  | 0       | 1 (to disable) |

## Build

## Clone this project

```bash
git clone https://github.com/madharjan/docker-nginx-web2py
cd docker-nginx-web2py
```

### Build Container

```bash
# login to DockerHub
docker login

# build
make

# tests
make run
make tests
make clean

# tag
make tag_latest

# release
make release
```

### Tag and Commit to Git

```bash
git tag 2.18.5
git push origin 2.18.5
```

## Run Container

### Nginx with Web2py (include Admin, Example and Welcome)

```bash
sudo mkdir -p /opt/docker/web2py/applications/
sudo mkdir -p /opt/docker/web2py/log/
```

#### Run `docker-nginx-web2py` with applications

```bash
docker stop web2py
docker rm web2py

docker run -d \
  -e WEB2PY_ADMIN=Pa55word! \
  -p 80:80 \
  -v /opt/docker/web2py/applications:/opt/web2py/applications \
  -v /opt/docker/web2py/log:/var/log/nginx \
  --name web2py \
  madharjan/docker-nginx-web2py:2.18.5
```

#### Systemd Unit file

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

### Nginx with Web2py Minimal

```bash
sudo mkdir -p /opt/docker/web2py/applications/
sudo mkdir -p /opt/docker/web2py/log/
```

#### Run `docker-nginx-web2py-min` with applications

```bash
docker stop web2py
docker rm web2py

docker run -d \
  -e WEB2PY_ADMIN=Pa55word \
  -p 80:80 \
  -v /opt/docker/web2py/applications:/opt/web2py/applications \
  -v /opt/docker/web2py/log:/var/log/nginx \
  --name web2py \
  madharjan/docker-nginx-web2py-min:2.18.5
```

### Systemd Unit - file

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
ExecStartPre=-/usr/bin/docker pull madharjan/docker-nginx-web2py-min:2.18.5

ExecStart=/usr/bin/docker run \
  -e WEB2PY_ADMIN=Pa55w0rd \
  -p 80:80 \
  -v /opt/docker/web2py/applications:/opt/web2py/applications \
  -v /opt/docker/web2py/log:/var/log/nginx \
  --name  web2py \
  madharjan/docker-nginx-web2py-min:2.18.5

ExecStop=/usr/bin/docker stop -t 2 web2py

[Install]
WantedBy=multi-user.target
```

### Generate Systemd Unit File - with deploy web projects

| Variable            | Default          | Example                                                          |
|---------------------|------------------|------------------------------------------------------------------|
| PORT                | 80               | 8080                                                             |
| VOLUME_HOME         | /opt/docker      | /opt/data                                                        |
| VERSION             | 2.18.5           | latest                                                           |
| WEB2PY_ADMIN        |                  | Pa55w0rd                                                         |
| WEB2PY_MIN          | true             | false                                                            |
| PROJECT_GIT_REPO    |                  | [https://github.com/madharjan/web2py-contest](https://github.com/madharjan/web2py-contest)                                                           |
| PROJECT_GIT_TAG     | HEAD             | v1.0                                                             |

```bash
docker run --rm -it \
  -e PORT=80 \
  -e VOLUME_HOME=/opt/docker \
  -e VERSION=2.18.5 \
  -e INSTALL_PROJECT=1 \
  -e PROJECT_GIT_REPO=https://github.com/madharjan/web2py-contest.git \
  -e PROJECT_GIT_TAG=HEAD \
  madharjan/docker-nginx-web2py-min:2.18.5 \
  /bin/sh -c "web2py-systemd-unit" | \
  sudo tee /etc/systemd/system/web2py-app.service

sudo systemctl enable web2py-app
sudo systemctl start web2py-app
```
