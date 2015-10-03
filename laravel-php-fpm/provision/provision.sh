#!/bin/bash

# ------------------------------------------------------------------------------
# Supervisor
# ------------------------------------------------------------------------------

mkdir -p /etc/supervisord/
mkdir /var/log/supervisord

cp /provision/supervisor.php-fpm.conf /etc/supervisord/
cp /provision/supervisor.queue.conf /etc/supervisord/

# copy all conf files
cp /provision/supervisor.conf /etc/supervisord.conf
cp /provision/service/* /etc/supervisord/

curl https://bootstrap.pypa.io/ez_setup.py -o - | python

easy_install supervisor

# ------------------------------------------------------------------------------
# PHP5
# ------------------------------------------------------------------------------

# copy FPM and CLI PHP configurations
cp /provision/php.fpm.ini /etc/php5/fpm/php.ini
cp /provision/php.cli.ini /etc/php5/cli/php.ini

# enable PHP mcrypt extension
php5enmod mcrypt

# disable 'daemonize' in php5-fpm (because we use supervisor instead)
sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf

# Install Mailparse PECL Extension
pecl install mailparse
echo "extension=mailparse.so" > /etc/php5/mods-available/mailparse.ini
ln -s /etc/php5/mods-available/mailparse.ini /etc/php5/cli/conf.d/20-mailparse.ini

sed -i "s/listen = \/var.*/listen = 0.0.0.0:9000/" /etc/php5/fpm/pool.d/www.conf

service php5-fpm restart

# ------------------------------------------------------------------------------
# Node and npm
# ------------------------------------------------------------------------------

npm install -g grunt-cli
npm install -g gulp
npm install -g bower

# ------------------------------------------------------------------------------
# Composer PHP dependency manager
# ------------------------------------------------------------------------------

# install the latest version of composer
php -r "readfile('https://getcomposer.org/installer');" | php
mv composer.phar /usr/local/bin/composer

# ------------------------------------------------------------------------------
# Clean up
# ------------------------------------------------------------------------------
rm -rf /provision