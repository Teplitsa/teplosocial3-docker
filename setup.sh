#!/bin/bash

NORMAL_COLOR="\033[0m"
RED_COLOR="\033[0;31m"
GREEN_COLOR="\033[0;32m"
BLUE_COLOR="\033[0;34m"

WP_PLUGIN_REPO_URL="https://downloads.wordpress.org/plugin/"
WP_DB_SOURCE_URL="https://kurs.te-st.ru/source-db_bc1eab85ac6e9eee68ee34d514d527f1.zip"
WP_UPLOADS_SOURCE_URL="https://kurs.te-st.ru/wp-content/uploads_bc1eab85ac6e9eee68ee34d514d527f1.zip"

SITE_URL="http:\/\/teplosocial.tep" # escape some staff for sed command

MYSQL_DB_NAME="kurs"
MYSQL_USER="kurs_user"
MYSQL_PASSWORD="DevdrOvsFK4i7"
MYSQL_ROOT_PASSWORD="RootdrOvsFK4i7"

GIT_VERSION="$(git --version)"
WP_CORE_VERSION="5.6.1"

FRONTEND_REPO="teplosocial3-frontend"
MICROSERVICES_REPO="teplosocial3-microservices"
BACKEND_REPO="teplosocial3-backend"
BACKEND_PLUGIN_REPO="teplosocial3-backend-plugin"
ATVETKA_PLUGIN_REPO="tst-atvetka"

if [ -d "../mysql" ]; then
  echo -e "${BLUE_COLOR}INFO: ${NORMAL_COLOR}MySQL directory has already existed."
else
  echo -e "${BLUE_COLOR}INFO: ${NORMAL_COLOR}MySQL directory are creating..."

  mkdir ../mysql
fi

if [ -f "../mysql/source-db.sql" ]; then
  echo -e "${BLUE_COLOR}INFO: ${NORMAL_COLOR}MySQL dump has already had a dump."
else
  if [ $(curl -o /dev/null --silent -Iw '%{http_code}' "${WP_DB_SOURCE_URL}") == 200 ]; then
    echo -e "${BLUE_COLOR}INFO: ${NORMAL_COLOR}Mysql dump are downloading..."

    curl "${WP_DB_SOURCE_URL}" \
      --output ../mysql/source-db.zip \
      --location \
      --silent

    echo -e "${BLUE_COLOR}INFO: ${NORMAL_COLOR}Mysql dump are unzipping..."

    unzip -q ../mysql/source-db.zip -d ../mysql

    rm ../mysql/source-db.zip
  fi
fi

if [ -d "../mongo" ]; then
  echo -e "${BLUE_COLOR}INFO: ${NORMAL_COLOR}MongoDB directory has already existed."
else
  echo -e "${BLUE_COLOR}INFO: ${NORMAL_COLOR}MongoDB directory are creating..."

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
    sed "s/^.\+DB_NAME.\+$/define('DB_NAME', '${MYSQL_DB_NAME}');/" | \
    sed "s/^.\+DB_USER.\+$/define('DB_USER', '${MYSQL_USER}');/" | \
    sed "s/^.\+DB_PASSWORD.\+$/define('DB_PASSWORD', '${MYSQL_PASSWORD}');/" | \
    sed "s/^.\+DB_HOST.\+$/define('DB_HOST', 'teplosocial-mysql');/" | \
    sed "s/^\$table_prefix.\+$/\$table_prefix = 'gghaq_';/" | \
    sed "s/^define.\+WP_DEBUG.\+$/define('WP_DEBUG', true);\ndefine('WP_DEBUG_DISPLAY', false);\ndefine('WP_DEBUG_LOG', true);/" | \
    sed "s/^.\+stop editing.\+$/\n\ndefine('WP_HOME', '${SITE_URL}');\ndefine('WP_SITEURL', '${SITE_URL}');\ndefine('UPLOADS', 'wp-content\/uploads');/" \
    > ../wordpress/wp-config.php

  rm ../wordpress/wp-config-sample.php

  if [ -d "../wordpress/wp-content/uploads" ]; then
    echo -e "${BLUE_COLOR}INFO: ${NORMAL_COLOR}Uploads directory has already existed locally."
  else
    if [ $(curl -o /dev/null --silent -Iw '%{http_code}' "${WP_UPLOADS_SOURCE_URL}") == 200 ]; then
      echo -e "${BLUE_COLOR}INFO: ${NORMAL_COLOR}Uploads directory are downloading..."

      curl "${WP_UPLOADS_SOURCE_URL}" \
        --output uploads.zip \
        --location \
        --silent

      echo -e "${BLUE_COLOR}INFO: ${NORMAL_COLOR}Uploads directory are unzipping..."

      unzip -q uploads.zip -d "../wordpress/wp-content"

      rm uploads.zip
    fi
  fi

  if [ -f "./wp-plugins.csv" ]; then
    while IFS="," read -r plugin_name plugin_version plugin_url
    do
      if [ $plugin_name == "tst-atvetka" ]; then
        continue
      fi

      if [ $plugin_name == "tps-backend-plugin" ]; then
        continue
      fi

      if [ -d "../wordpress/wp-content/plugins/${plugin_name}" ]; then
        echo -e "${BLUE_COLOR}INFO: ${NORMAL_COLOR}The plugin ${plugin_name} has already existed locally."
      else
        echo -e "${BLUE_COLOR}INFO: ${NORMAL_COLOR}The plugin ${plugin_name} are downloading..."

        archive_name="${plugin_name}.zip"
        archive_url=""

        if [ $(curl -o /dev/null --silent -Iw '%{http_code}' "${WP_PLUGIN_REPO_URL}/${plugin_name}.${plugin_version}.zip") == 200 ]; then
          archive_url="${WP_PLUGIN_REPO_URL}/${plugin_name}.${plugin_version}.zip"
        elif [ $(curl -o /dev/null --silent -Iw '%{http_code}' "${WP_PLUGIN_REPO_URL}/${plugin_name}.zip") == 200 ]; then
          archive_url="${WP_PLUGIN_REPO_URL}/${plugin_name}.zip"
        else
          archive_url="${plugin_url}"
        fi

        if [ $archive_url == "" ]; then
          continue
        fi

        curl "${archive_url}" \
          --output "${archive_name}" \
          --location \
          --silent

        echo -e "${BLUE_COLOR}INFO: ${NORMAL_COLOR}The plugin ${plugin_name} are unzipping..."

        unzip -q "${archive_name}" -d "../wordpress/wp-content/plugins"

        rm "${archive_name}"
      fi
    done < <(tail -n +2 ./wp-plugins.csv)
  fi
fi

if [ "$GIT_VERSION" != "command not found" ]; then

  if [ -d "../nextjs" ]; then
    echo -e "${BLUE_COLOR}INFO: ${NORMAL_COLOR}Frontend repo has already existed locally."
  else
    echo -e "${BLUE_COLOR}INFO: ${NORMAL_COLOR}Frontend repo are clonning..."

    git clone -q "git@github.com:Teplitsa/${FRONTEND_REPO}.git" "../nextjs" \
      -b main
  fi

  if [ -d "../microservices" ]; then
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

    if [ -d "../wordpress/wp-content/plugins/sfwd-lms" ]; then
      echo -e "${BLUE_COLOR}INFO: ${NORMAL_COLOR}LearnDash are being patched..."

      cp -f \
        ../wordpress/wp-content/themes/teplosocial-backend/ld-patch/sfwd-lms/includes/rest-api/v1/class-ld-rest-quizzes-controller.php \
        ../wordpress/wp-content/plugins/sfwd-lms/includes/rest-api/v1/class-ld-rest-quizzes-controller.php

      cp -f \
        ../wordpress/wp-content/themes/teplosocial-backend/ld-patch/sfwd-lms/includes/lib/wp-pro-quiz/lib/view/WpProQuiz_View_QuestionEdit.php \
        ../wordpress/wp-content/plugins/sfwd-lms/includes/lib/wp-pro-quiz/lib/view/WpProQuiz_View_QuestionEdit.php

      cp -f \
        ../wordpress/wp-content/themes/teplosocial-backend/ld-patch/sfwd-lms/includes/lib/wp-pro-quiz/lib/controller/WpProQuiz_Controller_Question.php \
        ../wordpress/wp-content/plugins/sfwd-lms/includes/lib/wp-pro-quiz/lib/controller/WpProQuiz_Controller_Question.php
    fi
  fi

  if [ -d "../wordpress/wp-content/plugins/tps-backend-plugin" ]; then
    echo -e "${BLUE_COLOR}INFO: ${NORMAL_COLOR}Backend plugin repo has already existed locally."
  else
    echo -e "${BLUE_COLOR}INFO: ${NORMAL_COLOR}Backend plugin repo are clonning..."

    git clone -q "git@github.com:Teplitsa/${BACKEND_PLUGIN_REPO}.git" "../wordpress/wp-content/plugins/tps-backend-plugin" \
      -b main
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