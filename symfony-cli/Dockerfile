FROM php:alpine

RUN apk update \
  && apk add \
  git \
  curl \
  bash

RUN mkdir -p /usr/local/bin \
  && curl -LsS https://get.symfony.com/cli/installer -o /usr/local/bin/installer \
  && chmod a+x /usr/local/bin/installer \
  && /usr/local/bin/installer \
  && mv /root/.symfony/bin/symfony /usr/local/bin/symfony \
  && chmod a+x /usr/local/bin/symfony \
  && rm /usr/local/bin/installer

CMD ["symfony"]
