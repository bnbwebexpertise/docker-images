#!/bin/bash

service postgresql start
/usr/bin/renderd -f -c /etc/renderd.conf &

sleep 5

/usr/sbin/apache2 -D FOREGROUND