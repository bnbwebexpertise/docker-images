FROM instrumentisto/rsync-ssh:latest
MAINTAINER Jeremy Gaulin <jeremy@bnb.re>

# System update
RUN apk update \
 && apk upgrade \
 && apk add --no-cache \
            curl \
            bash \
            gawk \
            sed \
            grep \
            bc \
            coreutils \
            sshpass \
 && rm -rf /var/cache/apk/*
