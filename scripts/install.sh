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

if [ "${WEB2PY_MIN}" == false ]; then
  apt-get install -y --no-install-recommends git-core
  pip install gitpython
fi

## Install Web2py
cd /opt
wget http://web2py.com/examples/static/web2py_src.zip
mkdir tmp
unzip web2py_src.zip -d tmp

if [ "${WEB2PY_MIN}" == true ]; then
  cd tmp/web2py
  python scripts/make_min_web2py.py ../../tmp/web2py-min
  mv ../../tmp/web2py-min ../../web2py
  cd ../../
else
  mv tmp/web2py web2py
fi

rm web2py_src.zip
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
