FROM php:8.0
MAINTAINER Jeremy Gaulin <jeremy@bnb.re>

# System update
RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    gnupg \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libbz2-dev \
    libcurl4-openssl-dev \
    libc-client-dev \
    libkrb5-dev \
    libgssapi-krb5-2 \
    libmagickwand-dev \
    libmagickcore-dev \
    libonig-dev \
    imagemagick \
    curl \
    git \
    unzip \
    zip \
    libzip-dev \
    lftp \
  && curl -sL https://deb.nodesource.com/setup_12.x | bash - \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    nodejs \
  && rm -r /var/lib/apt/lists/*

# More

# Configure PHP Extensions
RUN docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
  && docker-php-ext-configure calendar \
  && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
  && docker-php-ext-configure zip --with-zip

# Install PHP Extensions
RUN docker-php-ext-install zip bz2 mbstring pdo_mysql tokenizer gd calendar bcmath exif curl imap \
  && docker-php-ext-enable zip bz2 mbstring pdo_mysql tokenizer gd calendar bcmath exif curl imap

# Install Imagick Extension
RUN pecl install imagick igbinary redis\
  && docker-php-ext-enable imagick igbinary redis exif

# Run xdebug installation.
RUN mkdir -p /usr/src/php/ext && \
    curl -L https://xdebug.org/files/xdebug-3.0.4.tgz >> /usr/src/php/ext/xdebug.tgz && \
    tar -xf /usr/src/php/ext/xdebug.tgz -C /usr/src/php/ext/ && \
    rm /usr/src/php/ext/xdebug.tgz && \
    docker-php-ext-install xdebug-3.0.4 && \
    docker-php-ext-install pcntl && \
    php -m

# Memory Limit & Time Zone
RUN echo "memory_limit=-1" > $PHP_INI_DIR/conf.d/memory-limit.ini && \
    echo "date.timezone=Indian/Reunion" > $PHP_INI_DIR/conf.d/date_timezone.ini

VOLUME /root/composer

# Environmental Variables
ENV COMPOSER_HOME /root/composer

# Install Bower, Gulp, Yarn
RUN npm config set unsafe-perm true
RUN npm install -g bower gulp yarn

# Install Composer > 2.0.8
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Goto temporary directory.
WORKDIR /tmp

# Run composer and phpunit installation.
RUN echo '>= 1.0.0'
RUN composer selfupdate --2 && \
    composer require "phpunit/phpunit:^9.0" --prefer-source --no-interaction && \
    ln -s /tmp/vendor/bin/phpunit /usr/local/bin/phpunit

RUN php -m && echo "============================================="

# Display PHP version
RUN echo 'PHP Version' && \
    php --version
RUN echo 'Composer Version' && \
    composer --version
RUN echo 'Npm Version' && \
    npm --version
RUN echo 'Bower Version' && \
    bower --version
RUN echo 'Yarn Version' && \
    yarn --version
RUN echo 'Gulp Version' && \
    gulp --version
