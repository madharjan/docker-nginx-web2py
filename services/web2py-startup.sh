#!/bin/bash

set -e

if [ "${DEBUG}" = true ]; then
  set -x
fi

DISABLE_UWSGI=${DISABLE_UWSGI:-0}
WEB2PY_ADMIN=${WEB2PY_ADMIN:-}
WEB2PY_MIN=${WEB2PY_MIN:-}

if [ ! "${DISABLE_UWSGI}" -eq 0 ]; then
  touch /etc/service/uwsgi/down
else
  rm -f /etc/service/uwsgi/down
fi

if [ ! -f "/etc/nginx/conf.d/default-web2py.conf" ]; then
  cp /config/etc/nginx-web2py/conf.d/default-web2py.conf /etc/nginx/conf.d/default-web2py.conf
fi

# delete default conf created by nginx-startup.sh
rm -f /etc/nginx/conf.d/default.conf

if [ "${WEB2PY_MIN}" == true ]; then
  if [ ! -d "/opt/web2py/applications/welcome" ]; then
    cp -r /config/opt/web2py/applications/welcome /opt/web2py/applications
  fi
else
  if [ ! -d "/opt/web2py/applications/admin" ]; then
    cp -r /config/opt/web2py/applications/admin /opt/web2py/applications
  fi
  if [ ! -d "/opt/web2py/applications/examples" ]; then
    cp -r /config/opt/web2py/applications/examples /opt/web2py/applications
  fi
  if [ ! -d "/opt/web2py/applications/welcome" ]; then
    cp -r /config/opt/web2py/applications/welcome /opt/web2py/applications
  fi
fi

chown -R www-data:www-data /opt/web2py/applications

if [ -z "${WEB2PY_ADMIN}" ]; then
  echo " WEB2PY_ADMIN not set, Admin application will be disabled"
else
  cd /opt/web2py;
  ./web2py-setpass ${WEB2PY_ADMIN}
fi
