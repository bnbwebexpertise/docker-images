FROM php:7.2
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
    libmagickwand-dev \
    libmagickcore-dev \
    imagemagick \
    curl \
    git \
    unzip \
  && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    nodejs \
  && rm -r /var/lib/apt/lists/*

# PHP Extensions
RUN docker-php-ext-install zip bz2 mbstring curl json pdo_mysql tokenizer \
  && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install gd \
  && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
  && docker-php-ext-install bcmath imap \
  && pecl install imagick \
  && docker-php-ext-enable imagick

# Run xdebug installation.
RUN mkdir -p /usr/src/php/ext && \
    curl -L https://xdebug.org/files/xdebug-2.6.0.tgz >> /usr/src/php/ext/xdebug.tgz && \
    tar -xf /usr/src/php/ext/xdebug.tgz -C /usr/src/php/ext/ && \
    rm /usr/src/php/ext/xdebug.tgz && \
    docker-php-ext-install xdebug-2.6.0 && \
    docker-php-ext-install pcntl && \
    php -m

# Memory Limit & Time Zone
RUN echo "memory_limit=-1" > $PHP_INI_DIR/conf.d/memory-limit.ini && \
    echo "date.timezone=Indian/Reunion" > $PHP_INI_DIR/conf.d/date_timezone.ini

VOLUME /root/composer

# Environmental Variables
ENV COMPOSER_HOME /root/composer

# Install Bower, Gulp, Yarn
RUN npm install -g bower gulp yarn

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Goto temporary directory.
WORKDIR /tmp

# Run composer and phpunit installation.
RUN composer selfupdate && \
    composer require "phpunit/phpunit:6.5.7" --prefer-source --no-interaction && \
    ln -s /tmp/vendor/bin/phpunit /usr/local/bin/phpunit

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
