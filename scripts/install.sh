#!/bin/bash
set -e
export LC_ALL=C
export DEBIAN_FRONTEND=noninteractive

if [ "${DEBUG}" = true ]; then
  set -x
fi

NGINX_CONFIG_PATH=/build/config/nginx-web2py

apt-get update

mkdir -p /config/etc/nginx-web2py/conf.d
cp ${NGINX_CONFIG_PATH}/default-web2py.conf /config/etc/nginx-web2py/conf.d/default-web2py.conf

## Install uwsgi and runit service
/build/services/uwsgi/uwsgi.sh

apt-get install -y --no-install-recommends git-core
pip install gitpython

## Install Web2py
mkdir -p /opt/tmp
cd /opt/tmp
git clone https://github.com/web2py/web2py.git --depth 1 --branch R-2.14.6 --single-branch web2py
cd web2py
git submodule update --init --recursive
cd ../../

if [ "${WEB2PY_MIN}" == true ]; then
  cd tmp/web2py
  python scripts/make_min_web2py.py ../../tmp/web2py-min
  mv ../../tmp/web2py-min ../../web2py
  cd ../../
else
  mv tmp/web2py web2py
fi

rm -rf tmp
mv web2py/handlers/wsgihandler.py web2py/wsgihandler.py

cp /build/bin/web2py-setpass /opt/web2py
chmod 750 /opt/web2py/web2py-setpass

chown -R www-data:www-data /opt/web2py

mkdir -p /etc/my_init.d
cp /build/services/web2py-startup.sh /etc/my_init.d
chmod 750 /etc/my_init.d/web2py-startup.sh

mkdir -p /config/opt/web2py/applications
cp -r /opt/web2py/applications/* /config/opt/web2py/applications
