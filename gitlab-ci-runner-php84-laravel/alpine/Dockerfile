# --- 1. Builder stage ---
FROM php:8.4-cli-alpine AS builder

ARG PHP_BUILD_DEPS="autoconf make g++ libtool linux-headers \
    imagemagick-dev pkgconfig freetype-dev libpng-dev libjpeg-turbo-dev icu-dev libzip-dev git \
    oniguruma-dev postgresql-dev libxml2-dev bzip2-dev"
ARG PHP_RUN_DEPS="bzip2 libzip freetype libjpeg libpng icu-libs libpq libxml2"

RUN apk add --no-cache $PHP_BUILD_DEPS $PHP_RUN_DEPS \
    && pecl install igbinary redis xdebug imagick \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
         zip bz2 mbstring pdo_mysql pdo_pgsql gd calendar bcmath exif intl pcntl xml dom simplexml xmlwriter sockets \
    && docker-php-ext-enable igbinary redis imagick xdebug \
    && rm -rf /tmp/* /var/cache/apk/*

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer selfupdate --2 \
    && mkdir /usr/local/composer \
    && cd /usr/local/composer \
    && composer require "phpunit/phpunit:^11.0" --no-interaction

# --- 2. Final stage ---
FROM php:8.4-cli-alpine

# Copier uniquement les extensions et binaires nécessaires
COPY --from=builder /usr/local/lib/php/extensions /usr/local/lib/php/extensions
COPY --from=builder /usr/local/bin/composer /usr/local/bin/composer
COPY --from=builder /usr/local/composer /usr/local/composer
COPY --from=builder /usr/local/etc/php/conf.d /usr/local/etc/php/conf.d

ARG PHP_RUN_DEPS="bzip2 libzip freetype libjpeg libpng libcurl icu-libs imagemagick git nodejs-current npm libpq libxml2 oniguruma"

# Installer les dépendances runtime et configurer PHP
RUN apk add --no-cache $PHP_RUN_DEPS \
    && rm -rf /tmp/* /var/cache/apk/* \
    && echo "memory_limit=-1" > $PHP_INI_DIR/conf.d/memory-limit.ini \
    && echo "date.timezone=Indian/Reunion" > $PHP_INI_DIR/conf.d/date_timezone.ini \
    && ln -s /usr/local/composer/bin/phpunit /usr/local/bin/phpunit

WORKDIR /app
VOLUME /root/composer
ENV COMPOSER_HOME=/root/composer
