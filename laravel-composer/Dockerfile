# ------------------------------------------------------------------------------
# Docker provisioning script for the Laravel web server stack
#
# 	e.g. docker build -t bnbwebexpertise/laravel-composer .
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# Start with the official Ubuntu 14.04 base image
# ------------------------------------------------------------------------------

FROM ubuntu-debootstrap:14.04

MAINTAINER Jérémy Gaulin <contact@gabsource.com>

# Set correct environment variables
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

# ------------------------------------------------------------------------------
# Setup Timezone
# ------------------------------------------------------------------------------

RUN echo "Indian/Reunion" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata

# ------------------------------------------------------------------------------
# Set locale (support UTF-8 in the container terminal)
# ------------------------------------------------------------------------------

RUN locale-gen fr_FR.UTF-8
ENV LANG fr_FR.UTF-8
ENV LANGUAGE fr_FR:fr
ENV LC_ALL fr_FR.UTF-8

# ------------------------------------------------------------------------------
# Provision the server
# ------------------------------------------------------------------------------

RUN apt-get update && \
    apt-get install -y \
        software-properties-common \
        python-software-properties \
    && \
    add-apt-repository ppa:ondrej/php5-5.6

RUN apt-get update && \
    apt-get install -y --force-yes \
        curl \
        libcurl3 \
        libcurl3-dev \
        python \
        git \
        nodejs-legacy \
        npm \
        sqlite3 \
        libsqlite3-dev \
        php5-cli \
        php5-dev \
        php-pear \
        php5-curl \
        php5-mysqlnd \
        php5-pgsql \
        php5-sqlite \
        php5-apcu \
        php5-json \
        php5-curl \
        php5-gd \
        php5-gmp \
        php5-imap \
        php5-mcrypt \
        php5-memcached


RUN mkdir /provision
ADD provision /provision
RUN /provision/provision.sh

# ------------------------------------------------------------------------------
# Expose ports
# ------------------------------------------------------------------------------

RUN usermod -u 1000 www-data

# ------------------------------------------------------------------------------
# Clean up
# ------------------------------------------------------------------------------

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*