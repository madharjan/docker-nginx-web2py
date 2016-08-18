#!/bin/bash
set -e
source /build/config/buildconfig

if [ "$DEBUG" == true ]; then
  set -x
fi

apt-get clean
rm -rf /build
rm -rf /tmp/* /var/tmp/*
rm -rf /var/lib/apt/lists/*
rm -f /etc/dpkg/dpkg.cfg.d/02apt-speedup
