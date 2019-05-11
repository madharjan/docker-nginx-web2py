#!/bin/sh

set -e

if [ "${DEBUG}" = true ]; then
  set -x
fi

INSTALL_PROJECT=${INSTALL_PROJECT:-0}

if [ ! "${INSTALL_PROJECT}" -eq 0 ]; then

  if [ -n "$PROJECT_GIT_REPO" ]; then

    FOLDER=$(echo $(basename $PROJECT_GIT_REPO) | cut -d"." -f1)
    mkdir -p /opt/web2py/applications/${FOLDER}
    rsync -avh --remove-source-files --delete /var/www/html/* /opt/web2py/applications/${FOLDER}/
    find . -type d -empty -delete
    
  fi

fi
