#!/usr/bin/env sh

set -e

### opcache preload mock
mkdir -p /var/www/config
echo '<?php' > /var/www/config/preload.php

### Required dependencies
### [composer install] edsdk/flmngr-server-php 1.0.35 requires ext-gd *
### [composer install] friendsofsymfony/ckeditor-bundle 2.3.0 requires ext-zip *
### [composer] unzip needed to keep files permissions (https://github.com/composer/composer/issues/4471)
### [doctrine] ext-pdo_mysql
### [application] ext-soap
### [application] ext-intl
### [symfony-requirements] (recommended) op-cache

PHP_EXTENSIONS="gd zip pdo_mysql soap intl opcache"
RUN_DEPS="unzip libpng libzip icu"
BUILD_DEPS="autoconf g++ make libzip-dev zlib-dev libpng-dev libxml2-dev icu-dev"
PECL_EXTENSIONS="apcu"

apk add --no-cache --virtual rundeps ${RUN_DEPS}
apk add --no-cache --virtual .build-deps ${BUILD_DEPS}

docker-php-ext-install -j"$(nproc)" ${PHP_EXTENSIONS}

pecl install ${PECL_EXTENSIONS}
docker-php-ext-enable ${PECL_EXTENSIONS}

apk del .build-deps
