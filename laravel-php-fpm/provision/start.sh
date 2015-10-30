#!/bin/bash
sed -i "s/listen = .*/listen = 0.0.0.0:${PHP_DOWNSTREAM_PORT}/" /etc/php5/fpm/pool.d/www.conf
/usr/local/bin/supervisord -c /etc/supervisord.conf