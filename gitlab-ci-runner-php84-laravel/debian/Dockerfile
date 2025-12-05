FROM php:8.4-cli
LABEL maintainer="Jeremy Gaulin <jeremy.gaulin@bnb.re>"

# System update
RUN apt-get update \
  && apt-get -yq upgrade \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    gnupg \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libbz2-dev \
    libcurl4-openssl-dev \
    libmagickwand-dev \
    libmagickcore-dev \
    libonig-dev \
    libpq-dev \
    libxml2-dev \
    libicu-dev \
    imagemagick \
    curl \
    git \
    unzip \
    zip \
    libzip-dev \
    lftp

RUN curl -sL https://deb.nodesource.com/setup_22.x | bash - \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs

# Configure PHP Extensions
RUN docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
  && docker-php-ext-configure calendar \
  && docker-php-ext-configure zip --with-zip

# Install PHP Extensions
RUN docker-php-ext-install -j$(nproc) \
    zip bz2 mbstring pdo_mysql pdo_pgsql gd calendar bcmath exif intl pcntl \
    xml dom simplexml xmlwriter sockets

# Install PECL extensions
RUN pecl install igbinary redis \
  && docker-php-ext-enable igbinary redis

# Install XDebug
RUN mkdir -p /usr/src/php/ext \
    && curl -L https://xdebug.org/files/xdebug-3.4.0.tgz >> /usr/src/php/ext/xdebug.tgz \
    && tar -xf /usr/src/php/ext/xdebug.tgz -C /usr/src/php/ext/ \
    && rm /usr/src/php/ext/xdebug.tgz \
    && docker-php-ext-install xdebug-3.4.0

# Install Imagick
RUN pecl install imagick \
    && docker-php-ext-enable imagick

# Cleanup
RUN apt-get purge -y $PHP_DEV_DEPS $PHPIZE_DEPS \
    && apt-get autoremove -y --purge \
    && apt-get clean all \
    && rm -r /var/lib/apt/lists/*

# PHP config
RUN echo "memory_limit=-1" > $PHP_INI_DIR/conf.d/memory-limit.ini && \
    echo "date.timezone=Indian/Reunion" > $PHP_INI_DIR/conf.d/date_timezone.ini

VOLUME /root/composer
ENV COMPOSER_HOME=/root/composer

# Install Yarn
RUN npm install -g yarn

WORKDIR /tmp

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer selfupdate --2

# Install PHPUnit
RUN composer require "phpunit/phpunit:^11.0" --no-interaction \
    && ln -s /tmp/vendor/bin/phpunit /usr/local/bin/phpunit

# Display versions
RUN php --version && composer --version && npm --version && yarn --version && php -m
