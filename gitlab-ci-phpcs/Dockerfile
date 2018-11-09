FROM php:7.2
MAINTAINER Jeremy Gaulin <jeremy@bnb.re>

# System update
RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    git \
    curl \
    unzip \
    zlib1g-dev \
    libbz2-dev \
    libcurl4-openssl-dev \
  && rm -r /var/lib/apt/lists/*

# PHP Extensions
RUN docker-php-ext-install zip bz2 mbstring curl json tokenizer

# Environmental Variables
ENV COMPOSER_HOME /root/composer
ENV PATH "${COMPOSER_HOME}/vendor/bin:${PATH}"

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install PHP Code Sniffer
RUN composer global require squizlabs/php_codesniffer

ENTRYPOINT []