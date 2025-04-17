# --- 1. Builder stage ---
FROM php:8.3-cli-alpine AS builder

ARG PHP_RUN_DEPS="c-client"
ARG PHP_BUILD_DEPS="autoconf make g++ libtool linux-headers \
    imagemagick-dev pkgconfig freetype-dev libpng-dev libjpeg-turbo-dev icu-dev libzip-dev git \
    oniguruma-dev curl-dev imap-dev krb5-dev"
RUN apk add --no-cache $PHP_RUN_DEPS \
    && apk add --no-cache $PHP_BUILD_DEPS \
    && pecl install igbinary redis xdebug imagick \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-configure imap --with-imap-ssl --with-kerberos \
    && docker-php-ext-install -j$(nproc) \
         zip bz2 mbstring pdo_mysql gd calendar bcmath exif curl imap intl pcntl \
    && apk del --no-cache $PHP_BUILD_DEPS \
    && rm -rf /tmp/* /var/cache/apk/*
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer selfupdate --2 \
    && mkdir /usr/local/composer \
    && cd /usr/local/composer \
    && composer require "phpunit/phpunit:^11.0" --prefer-source --no-interaction

# --- 2. Final stage ---
FROM php:8.3-cli-alpine

# Copier uniquement les extensions et binaires nécessaires
COPY --from=builder /usr/local/lib/php/extensions /usr/local/lib/php/extensions
COPY --from=builder /usr/local/bin/composer /usr/local/bin/composer
COPY --from=builder /usr/local/composer /usr/local/composer
COPY --from=builder /usr/lib/libc-client.so.1 /usr/lib/
COPY --from=builder /usr/lib/libkrb5* /usr/lib/
COPY --from=builder /usr/lib/libssl.so.3 /usr/lib/
COPY --from=builder /usr/lib/libcrypto.so.3 /usr/lib/

ARG PHP_RUN_DEPS="bzip2 libzip freetype libjpeg libpng libcurl icu-libs imagemagick git nodejs-current npm"

# Activer les extensions compilées
RUN apk add --no-cache $PHP_RUN_DEPS \
    && rm -rf /tmp/* /var/cache/apk/* \
    && docker-php-ext-enable igbinary redis imagick xdebug zip bz2 mbstring pdo_mysql gd calendar bcmath exif curl imap intl pcntl \
    && echo "memory_limit=-1" > $PHP_INI_DIR/conf.d/memory-limit.ini \
    && echo "date.timezone=Indian/Reunion" > $PHP_INI_DIR/conf.d/date_timezone.ini \
    && ln -s /usr/local/composer/bin/phpunit /usr/local/bin/phpunit

WORKDIR /app
VOLUME /root/composer
ENV COMPOSER_HOME=/root/composer
