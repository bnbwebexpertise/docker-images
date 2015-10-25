#!/bin/bash

service postgresql start
service renderd start

/usr/sbin/apache2 -D FOREGROUND