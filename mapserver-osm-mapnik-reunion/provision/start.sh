#!/bin/bash

rm -f ${ENV APACHE_PID_FILE}

service postgresql start
service renderd start

sleep 5

/usr/sbin/apache2 -D FOREGROUND