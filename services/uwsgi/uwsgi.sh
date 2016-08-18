#!/bin/bash
set -e
source /build/config/buildconfig

if [ "$DEBUG" == true ]; then
  set -x
fi

UWSGI_BUILD_PATH=/build/services/uwsgi

## Install Nginx.
$minimal_apt_get_install build-essential python-dev libxml2-dev python-pip unzip
pip install setuptools --no-use-wheel --upgrade
PIPPATH=`which pip`
$PIPPATH install --upgrade uwsgi

mkdir -p /etc/uwsgi
cp ${UWSGI_BUILD_PATH}/uwsgi.ini /etc/uwsgi/

mkdir -p /etc/service/uwsgi
cp ${UWSGI_BUILD_PATH}/uwsgi.runit /etc/service/uwsgi/run
chmod 750 /etc/service/uwsgi/run

mkdir -p /var/log/uwsgi

## Configure logrotate.
