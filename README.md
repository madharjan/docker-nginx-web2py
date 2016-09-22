# docker-nginx-web2py

[![](https://images.microbadger.com/badges/image/madharjan/docker-nginx-web2py.svg)](http://microbadger.com/images/madharjan/docker-nginx-web2py "Get your own image badge on microbadger.com")

Docker container for Nginx with Web2py based on [madharjan/docker-nginx](https://github.com/madharjan/docker-nginx/)

* Nginx 1.4.6 & Web2py 2.14.6 (docker-nginx-web2py)

**Environment**

| Variable       | Default | Example        |
|----------------|---------|----------------|
| WEB2PY_ADMIN   |         | Pa55w0rd       |
| DISABLE_UWSGI  | 0       | 1 (to disable) |


## Build

**Clone this project**
```
git clone https://github.com/madharjan/docker-nginx-web2py
cd docker-nginx-web2py
```

**Build Containers**
```
# login to DockerHub
docker login

# build
make

# test
make run
make tests
make clean

# tag
make tag_latest

# update Makefile & Changelog.md
# release
make release
```

**Tag and Commit to Git**
```
git tag 1.4.6
git push origin 1.4.6
```

## Run Container

### Nginx with Web2py (include Admin, Example and Welcome)

**Prepare folder on host for container volumes**
```
sudo mkdir -p /opt/docker/web2py/applications/
sudo mkdir -p /opt/docker/web2py/log/
```

**Run `docker-nginx-web2py` with applications**
```
docker stop web2py
docker rm web2py

docker run -d -t \
  -e WEB2PY_ADMIN=Pa55word! \
  -p 80:80 \
  -v /opt/docker/web2py/applications:/opt/web2py/applications \
  -v /opt/docker/web2py/log:/var/log/nginx \
  --name web2py \
  madharjan/docker-nginx-web2py:2.14.6
```

**Systemd Unit file**
```
[Unit]
Description=Web2py Framework

After=docker.service

[Service]
TimeoutStartSec=0

ExecStartPre=-/bin/mkdir -p /opt/docker/web2py/applications
ExecStartPre=-/bin/mkdir -p /opt/docker/web2py/log
ExecStartPre=-/usr/bin/docker stop web2py
ExecStartPre=-/usr/bin/docker rm web2py
ExecStartPre=-/usr/bin/docker pull madharjan/docker-nginx-web2py:2.14.6

ExecStart=/usr/bin/docker run \
  -e WEB2PY_ADMIN=Pa55w0rd \
  -p 80:80 \
  -v /opt/docker/web2py/applications:/opt/web2py/applications \
  -v /opt/docker/web2py/log:/var/log/nginx \
  --name  web2py \
  madharjan/docker-nginx-web2py:2.14.6

ExecStop=/usr/bin/docker stop -t 2 web2py

[Install]
WantedBy=multi-user.target
```

### Nginx with Web2py Minimal

**Prepare folder on host for container volumes**
```
sudo mkdir -p /opt/docker/web2py/applications/
sudo mkdir -p /opt/docker/web2py/log/
```

**Run `docker-nginx-web2py-min` with applications**
```
docker stop web2py
docker rm web2py

docker run -d -t \
  -e WEB2PY_ADMIN=Pa55word \
  -p 80:80 \
  -v /opt/docker/web2py/applications:/opt/web2py/applications \
  -v /opt/docker/web2py/log:/var/log/nginx \
  --name web2py \
  madharjan/docker-nginx-web2py-min:2.14.6
```

**Systemd Unit file**
```
[Unit]
Description=Web2py Framework

After=docker.service

[Service]
TimeoutStartSec=0

ExecStartPre=-/bin/mkdir -p /opt/docker/web2py/applications
ExecStartPre=-/bin/mkdir -p /opt/docker/web2py/log
ExecStartPre=-/usr/bin/docker stop web2py
ExecStartPre=-/usr/bin/docker rm web2py
ExecStartPre=-/usr/bin/docker pull madharjan/docker-nginx-web2py-min:2.14.6

ExecStart=/usr/bin/docker run \
  -e WEB2PY_ADMIN=Pa55w0rd \
  -p 172.17.0.1:8080:80 \
  -v /opt/docker/web2py/applications:/opt/web2py/applications \
  -v /opt/docker/web2py/log:/var/log/nginx \
  --name  web2py \
  madharjan/docker-nginx-web2py-min:2.14.6

ExecStop=/usr/bin/docker stop -t 2 web2py

[Install]
WantedBy=multi-user.target
```
