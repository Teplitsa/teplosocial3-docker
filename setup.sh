#!/bin/bash

NORMAL_COLOR="\033[0m"
RED_COLOR="\033[0;31m"
GREEN_COLOR="\033[0;32m"
BLUE_COLOR="\033[0;34m"

SITE_URL="http:\/\/teplosocial.tep" # escape some staff for sed command

MYSQL_DB_NAME="dev_itv_kurs"
MYSQL_USER="dev_itv_kurs"
MYSQL_PASSWORD="DevdrOvsFK4i7"
MYSQL_ROOT_PASSWORD="RootdrOvsFK4i7"

GIT_VERSION="$(git --version)"
WP_CLI_VERSION="$(wp --version)"
WP_CORE_VERSION="5.9.3"

FRONTEND_REPO="teplosocial3-frontend"
MICROSERVICES_REPO="teplosocial3-microservices"
BACKEND_REPO="teplosocial3-backend"
BACKEND_PLUGIN_REPO="teplosocial3-backend"
ATVETKA_PLUGIN_REPO="tst-atvetka"

if [ -d "../mysql" ]; then
  echo -e "${BLUE_COLOR}INFO: ${NORMAL_COLOR}MySQL directory has already existed."
else
  echo -e "${BLUE_COLOR}INFO: ${NORMAL_COLOR}MySQL directory are creating..."

  mkdir ../mysql
fi

if [ -d "../mongo" ]; then
  echo -e "${BLUE_COLOR}INFO: ${NORMAL_COLOR}MongoDB directory are creating..."

  echo -e "${BLUE_COLOR}INFO: ${NORMAL_COLOR}MongoDB directory has already existed."
else
  mkdir ../mongo
fi

if [ -f "../wordpress/wp-config.php" ]; then
  echo -e "${BLUE_COLOR}INFO: ${NORMAL_COLOR}Wordpress Core has already downloaded."
else
  echo -e "${BLUE_COLOR}INFO: ${NORMAL_COLOR}WordPress Core are downloading..."

  curl "https://github.com/WordPress/WordPress/archive/refs/tags/${WP_CORE_VERSION}.zip" \
    --output wordpress-core.zip \
    --location \
    --silent

  echo -e "${BLUE_COLOR}INFO: ${NORMAL_COLOR}WordPress Core are unzipping..."

  unzip -q wordpress-core.zip -d ../

  rm wordpress-core.zip

  mv "../WordPress-${WP_CORE_VERSION}" ../wordpress

  echo -e "${BLUE_COLOR}INFO: ${NORMAL_COLOR}WordPress directory is created now."

  echo -e "${BLUE_COLOR}INFO: ${NORMAL_COLOR}WordPress config is customizing..."

  cat ../wordpress/wp-config-sample.php | \
    sed "s/^.*DB_NAME.*$/define('DB_NAME', '${MYSQL_DB_NAME}');/" | \
    sed "s/^.*DB_USER.*$/define('DB_USER', '${MYSQL_USER}');/" | \
    sed "s/^.*DB_PASSWORD.*$/define('DB_PASSWORD', '${MYSQL_PASSWORD}');/" | \
    sed "s/^.*DB_HOST.*$/define('DB_HOST', 'teplosocial-mysql:3306');/" | \
    sed "s/^\$table_prefix.*$/\$table_prefix = 'gghaq_';/" | \
    sed "s/^define.+WP_DEBUG.*$/define('WP_DEBUG', true);\ndefine('WP_DEBUG_DISPLAY', false);\ndefine('WP_DEBUG_LOG', true);/" | \
    sed "s/^.*Add any custom values.*$/\n\ndefine('WP_HOME', '${SITE_URL}');\ndefine('WP_SITEURL', '${SITE_URL}');\ndefine('UPLOADS', 'wp-content\/uploads');/" \
    > ../wordpress/wp-config.php

  rm ../wordpress/wp-config-sample.php
fi

if [ "$GIT_VERSION" != "command not found" ]; then

  if [ -d "../teplosocial-frontend" ]; then
    echo -e "${BLUE_COLOR}INFO: ${NORMAL_COLOR}Frontend repo has already existed locally."
  else
    echo -e "${BLUE_COLOR}INFO: ${NORMAL_COLOR}Frontend repo are clonning..."

    git clone -q "git@github.com:Teplitsa/${FRONTEND_REPO}.git" "../nextjs" \
      -b main
  fi

  if [ -d "../teplosocial-microservices" ]; then
    echo -e "${BLUE_COLOR}INFO: ${NORMAL_COLOR}Microservices repo has already existed locally."
  else
    echo -e "${BLUE_COLOR}INFO: ${NORMAL_COLOR}Microservices repo are clonning..."

    git clone -q "git@github.com:Teplitsa/${MICROSERVICES_REPO}.git" "../microservices" \
      -b main
  fi

  if [ -d "../wordpress/wp-content/themes/teplosocial-backend" ]; then
    echo -e "${BLUE_COLOR}INFO: ${NORMAL_COLOR}Backend repo has already existed locally."
  else
    echo -e "${BLUE_COLOR}INFO: ${NORMAL_COLOR}Backend repo are clonning..."

    git clone -q "git@github.com:Teplitsa/${BACKEND_REPO}.git" "../wordpress/wp-content/themes/teplosocial-backend" \
      -b main

    if [ -d "../wordpress/wp-content/themes/teplosocial-backend" ]; then
      echo -e "${BLUE_COLOR}INFO: ${NORMAL_COLOR}Backend plugin repo are clonning..."

      cp ../wordpress/wp-content/themes/teplosocial-backend/tps-backend-plugin ../wordpress/wp-content/plugins/tps-backend-plugin 
    fi
  fi

  if [ -d "../wordpress/wp-content/plugins/${ATVETKA_PLUGIN_REPO}" ]; then
    echo -e "${BLUE_COLOR}INFO: ${NORMAL_COLOR}Atvetka plugin repo has already existed locally."
  else
    echo -e "${BLUE_COLOR}INFO: ${NORMAL_COLOR}Atvetka plugin repo are clonning..."

    git clone -q "git@github.com:Teplitsa/${ATVETKA_PLUGIN_REPO}.git" "../wordpress/wp-content/plugins/${ATVETKA_PLUGIN_REPO}" \
      -b master
  fi

else
  echo -e "${RED_COLOR}ERROR: ${NORMAL_COLOR}Git is not installed."
fi

echo -e "${GREEN_COLOR}SUCCESS: ${NORMAL_COLOR}Done."