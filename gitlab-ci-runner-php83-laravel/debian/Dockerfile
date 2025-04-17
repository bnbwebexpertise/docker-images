FROM php:8.3-cli
MAINTAINER Jeremy Gaulin <jeremy@bnb.re>

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
    lftp
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs

# More

# Configure PHP Extensions
RUN docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
  && docker-php-ext-configure calendar \
  && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
  && docker-php-ext-configure zip --with-zip

# Install PHP Extensions
RUN docker-php-ext-install zip bz2 mbstring pdo_mysql gd calendar bcmath exif curl imap intl \
  && docker-php-ext-enable zip bz2 mbstring pdo_mysql gd calendar bcmath exif curl imap intl

# Install Imagick Extension
RUN pecl install igbinary redis \
  && docker-php-ext-enable igbinary redis exif

# Install XDebug from specific archive (PR's #616 code)

RUN mkdir -p /usr/src/php/ext \
    && curl -L https://xdebug.org/files/xdebug-3.3.1.tgz >> /usr/src/php/ext/xdebug.tgz \
    && tar -xf /usr/src/php/ext/xdebug.tgz -C /usr/src/php/ext/ \
    && rm /usr/src/php/ext/xdebug.tgz

RUN docker-php-ext-install xdebug-3.3.1 pcntl

RUN curl -L -o /tmp/imagick.tar.gz https://github.com/Imagick/imagick/archive/7088edc353f53c4bc644573a79cdcd67a726ae16.tar.gz \
    && tar --strip-components=1 -xf /tmp/imagick.tar.gz \
    && phpize \
    && ./configure \
    && make \
    && make install \
    && echo "extension=imagick.so" > /usr/local/etc/php/conf.d/ext-imagick.ini \
    && rm -rf /tmp/*

RUN php -m

# No more APT after this
RUN apt-get purge -y $PHP_DEV_DEPS $PHPIZE_DEPS \
    && apt-get autoremove -y --purge \
    && apt-get clean all \
    && rm -r /var/lib/apt/lists/*

# Memory Limit & Time Zone
RUN echo "memory_limit=-1" > $PHP_INI_DIR/conf.d/memory-limit.ini && \
    echo "date.timezone=Indian/Reunion" > $PHP_INI_DIR/conf.d/date_timezone.ini

VOLUME /root/composer

# Environmental Variables
ENV COMPOSER_HOME /root/composer

# Install Bower, Gulp, Yarn
RUN echo 'unsafe-perm=true' >> ~/.npmrc
RUN npm install -g bower gulp yarn

# Goto temporary directory.
WORKDIR /tmp


# Install Composer > 2.0.8
RUN echo '>= 2.0.8'
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer selfupdate --2
RUN composer require "phpunit/phpunit:^11.0" --prefer-source --no-interaction && \
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
