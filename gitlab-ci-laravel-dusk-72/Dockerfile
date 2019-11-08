FROM lorisleiva/laravel-docker:7.2

# Chromium For Dusk

RUN apk add --no-cache \
    chromium-chromedriver \
    chromium

# Customize PHP extensions

RUN apk add --no-cache \
    imap-dev

RUN docker-php-ext-install \
    imap
