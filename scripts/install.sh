#!/bin/bash
set -e
source /build/config/buildconfig
set -x

NGINX_CONFIG_PATH=/build/config/nginx

apt-get update
apt-get upgrade -y --no-install-recommends

rm /etc/nginx/conf.d/default.conf
cp ${NGINX_CONFIG_PATH}/nginx-default.conf /etc/nginx/conf.d/default.conf

## Install uwsgi and runit service
/build/services/uwsgi/uwsgi.sh

## Install web2py
cd /opt
wget http://web2py.com/examples/static/web2py_src.zip
mkdir tmp
unzip web2py_src.zip -d tmp
mv tmp/web2py web2py
rm web2py_src.zip
rm -rf tmp
mv web2py/handlers/wsgihandler.py web2py/wsgihandler.py
chown -R www-data:www-data web2py
