FROM ubuntu-debootstrap:14.04

MAINTAINER Jérémy Gaulin <contact@gabsource.com>

ENV DEBIAN_FRONTEND noninteractive
ENV OSM_EXTENT 54.993,-21.59624,56.0660,-20.6572

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

RUN usermod -u 1000 www-data

RUN apt-get update && \
    apt-get install -y \
        python-software-properties && \
    apt-add-repository -y ppa:git-core/ppa && \
    apt-add-repository -y ppa:ubuntugis/ppa && \
    add-apt-repository -y ppa:kakrueger/openstreetmap && \
    apt-get update && \
    apt-get dist-upgrade -y && \
    locale-gen en_US en_US.UTF-8 && \
    locale-gen fr_FR fr_FR.UTF-8 && \
    dpkg-reconfigure locales && \
    apt-get install -y \
        git \
        curl \
        wget \
        gdal-bin \
        sudo \
        mapnik-utils \
        unzip \
        libapache2-mod-tile \
        postgresql-9.3-postgis-2.1 \

RUN curl -L -o "/tmp/simplified-land-polygons-complete-3857.zip" "http://data.openstreetmapdata.com/simplified-land-polygons-complete-3857.zip" && \
    curl -L -o "/tmp/land-polygons-split-3857.zip" "http://data.openstreetmapdata.com/land-polygons-split-3857.zip" && \
    curl -L -o "/tmp/coastline-good.zip" "http://tilemill-data.s3.amazonaws.com/osm/coastline-good.zip" && \
    curl -L -o "/tmp/10m-land.zip" "http://mapbox-geodata.s3.amazonaws.com/natural-earth-1.3.0/physical/10m-land.zip" && \
    curl -L -o "/tmp/data.osm" "http://www.overpass-api.de/api/xapi?map?bbox=${OSM_EXTENT}"

RUN mkdir /provision
ADD provision /provision
RUN /provision/provision.sh

# ------------------------------------------------------------------------------
# Expose ports
# ------------------------------------------------------------------------------

EXPOSE 80

# ------------------------------------------------------------------------------
# CONFIGURE ENVIRONMENT
# ------------------------------------------------------------------------------

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_SERVERNAME mapserver.docker
ENV APACHE_SERVERADMIN webmaster@localhost
ENV MODTILE_REQUEST_TIMEOUT 2
ENV MODTILE_MISSING_REQUEST_TIMEOUT 10
ENV MODTILE_MAX_LOAD_OLD 2
ENV MODTILE_MAX_LOAD_MISSING 20
ENV MODTILE_CACHE_DURATION_MAX 604800
ENV MODTILE_CACHE_DURATION_DIRTY 900
ENV MODTILE_CACHE_DURATION_MINIMUM 10800
ENV MODTILE_CACHE_DURATION_MEDIUM_ZOOM 13 86400
ENV MODTILE_CACHE_DURATION_LOW_ZOOM 9 518400
ENV MODTILE_CACHE_LAST_MODIFIED_FACTOR 0.20

CMD ["/bin/bash", "/provision/start.sh"]

# ------------------------------------------------------------------------------
# Clean up
# ------------------------------------------------------------------------------

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*