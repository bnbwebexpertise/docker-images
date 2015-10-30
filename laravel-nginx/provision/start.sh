#!/bin/bash
echo "upstream php-upstream { server ${NGINX_UPSTREAM_SERVER}:${NGINX_UPSTREAM_PORT}; }" > /etc/nginx/conf.d/upstream.conf
nginx