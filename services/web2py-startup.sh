#!/bin/bash

set -e

if [ "$DEBUG" == true ]; then
  set -x
fi

if [ -z "$WEB2PY_ADMIN" ]; then
  echo " WEB2PY_ADMIN not set, Admin application will be disabled"
else
  cd /opt/web2py;
  ./web2py-setpass ${WEB2PY_ADMIN}
fi
