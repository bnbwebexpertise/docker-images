# ------------------------------------------------------------------------------
# Docker provisioning script for the Laravel web server stack
#
# 	e.g. docker build -t bnbwebexpertise/laravel-nginx .
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# Start with the official Ubuntu 14.04 base image
# ------------------------------------------------------------------------------

FROM ubuntu-debootstrap:14.04

CMD ["nginx"]

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
    apt-get install -y nginx

ADD provision/nginx.conf /etc/nginx/
ADD provision/laravel.conf /etc/nginx/sites-available/

RUN ln -s /etc/nginx/sites-available/laravel.conf /etc/nginx/sites-enabled/laravel
RUN rm /etc/nginx/sites-enabled/default

RUN echo "upstream php-upstream { server application:9000; }" > /etc/nginx/conf.d/upstream.conf

RUN usermod -u 1000 www-data

# ------------------------------------------------------------------------------
# Expose ports
# ------------------------------------------------------------------------------

EXPOSE 80

# ------------------------------------------------------------------------------
# Clean up
# ------------------------------------------------------------------------------

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*