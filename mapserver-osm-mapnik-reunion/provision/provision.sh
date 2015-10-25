#!/bin/bash

OSM_MIRROR_CONF=/etc/default/openstreetmap-conf
SITE_CONF=tileserver_site.conf
RENDERD_CONF=/etc/renderd.conf
STYLES_PATH=/etc/mapnik-osm-data/makina
PREVIEW_CONF=/var/www/conf.js


function echo_step () {
    echo -e "\e[92m\e[1m$1\e[0m"
}

function echo_error () {
    echo -e "\e[91m\e[1m$1\e[0m"
}

#.......................................................................

echo_step "Configure instance..."

if [[ -z "${OSM_EXTENT}" ]]; then
    read -e -p "Enter extent (xmin,ymin,xmax,ymax):  " -i "${OSM_EXTENT}" OSM_EXTENT
fi

cat << _EOF_ > $OSM_MIRROR_CONF
DB_NAME="gis"
DB_USER="gisuser"
DB_PASSWORD="corpus"
EXTENT="${OSM_EXTENT}"
_EOF_

source $OSM_MIRROR_CONF

#.......................................................................

mkdir /provision/osm-mirror && \
    cd /provision/osm-mirror

echo_step "Downloading installer source..."
git clone --recursive --depth=50 --branch=master https://github.com/makinacorpus/osm-mirror.git /tmp/osm-mirror
rm -f /tmp/osm-mirror/install.sh
shopt -s dotglob nullglob
cp -R /tmp/osm-mirror/* .


#.......................................................................

echo_step "Configure database..."

/etc/init.d/postgresql restart

sudo -n -u postgres -s -- psql -c "CREATE USER ${DB_USER} WITH PASSWORD '${DB_PASSWORD}';"
sudo -n -u postgres -s -- psql -c "CREATE DATABASE ${DB_NAME} OWNER ${DB_USER} ENCODING 'UTF8' TEMPLATE template0;"
sudo -n -u postgres -s -- psql -d ${DB_NAME} -c "CREATE EXTENSION postgis;"
sudo -n -u postgres -s -- psql -d ${DB_NAME} -c "GRANT ALL ON spatial_ref_sys, geometry_columns, raster_columns TO ${DB_USER};"
sudo -n -u postgres -s -- psql -d ${DB_NAME} -f /usr/share/postgresql/9.3/contrib/postgis-2.0/legacy.sql

cat << _EOF_ >> /etc/postgresql/9.3/main/pg_hba.conf
# Automatically added by OSM installation :
local    ${DB_NAME}     ${DB_USER}                 trust
host     ${DB_NAME}     ${DB_USER}   127.0.0.1/32  trust
_EOF_


#.......................................................................

OSM_DATA=/usr/share/mapnik-osm-data/world_boundaries

if [ ! -f $OSM_DATA/10m-land.shp ]; then
    echo_step "Load world boundaries data..."

    # Copy ne_10m_populated_places to ne_10m_populated_places_fixed
    rm -rf $OSM_DATA/ne_10m_populated_places_fixed.*
    ogr2ogr $OSM_DATA/ne_10m_populated_places_fixed.shp $OSM_DATA/ne_10m_populated_places.shp

    zipfile=/tmp/simplified-land-polygons-complete-3857.zip
    unzip -qqu $zipfile simplified-land-polygons-complete-3857/simplified_land_polygons.{shp,shx,prj,dbf,cpg} -d /tmp
    rm $zipfile
    mv /tmp/simplified-land-polygons-complete-3857/simplified_land_polygons.* $OSM_DATA/


    zipfile=/tmp/land-polygons-split-3857.zip
    unzip -qqu $zipfile -d /tmp
    rm $zipfile
    mv /tmp/land-polygons-split-3857/land_polygons.* $OSM_DATA/

    zipfile=/tmp/coastline-good.zip
    unzip -qqu $zipfile -d /tmp
    rm $zipfile
    mv /tmp/coastline-good.* $OSM_DATA/

    zipfile=/tmp/10m-land.zip
    unzip -qqu $zipfile -d /tmp
    rm $zipfile
    mv /tmp/10m-land.* $OSM_DATA/

    shapeindex --shape_files \
    $OSM_DATA/simplified_land_polygons.shp \
    $OSM_DATA/land_polygons.shp \
    $OSM_DATA/coastline-good.shp \
    $OSM_DATA/10m-land.shp \
    $OSM_DATA/shoreline_300.shp \
    $OSM_DATA/ne_10m_populated_places_fixed.shp
fi


#.......................................................................

echo_step "Deploy preview map..."

rm /var/www/index.html
cp -R preview/* /var/www/


#.......................................................................

echo_step "Load into database..."

output=/tmp/data.osm

sudo -n -u postgres -s -- osm2pgsql -d ${DB_NAME} --extra-attributes --create ${output}
if [ $? -eq 0 ]; then
    rm ${output}
fi

#.......................................................................

echo_step "Grant rights on OSM tables..."

/usr/bin/install-postgis-osm-user.sh ${DB_NAME} www-data 2> /dev/null
/usr/bin/install-postgis-osm-user.sh ${DB_NAME} gisuser 2> /dev/null

#.......................................................................

echo_step "Deploy map styles..."

if [ ! -d styles ]; then
    echo_error "Styles folder missing"
    exit 6
fi

mkdir -p $STYLES_PATH
cp -R styles/* $STYLES_PATH


#.......................................................................

echo_step "Update renderd configuration..."


cat << _EOF_ > $RENDERD_CONF
[renderd]
stats_file=/var/run/renderd/renderd.stats
socketname=/var/run/renderd/renderd.sock
num_threads=2

[mapnik]
plugins_dir=/usr/lib/mapnik/2.0/input
font_dir=/usr/share/fonts/truetype/ttf-dejavu
font_dir_recurse=false

_EOF_


for style in `ls ./styles/`; do
    cat << _EOF_ >> $RENDERD_CONF
[$style]
URI=/$style/
XML=$STYLES_PATH/$style/$style.xml
DESCRIPTION=$style
MINZOOM=0
MAXZOOM=20

_EOF_
done;


#.......................................................................

echo_step "Update map preview configuration..."

cat << _EOF_ > $PREVIEW_CONF
var SETTINGS = {
    extent: [${OSM_EXTENT}],
    layers: {
_EOF_

for style in `ls ./styles/`; do
cat << _EOF_ >> $PREVIEW_CONF
'/$style/{z}/{x}/{y}.png': '/$style/{z}/{x}/{y}.png',
_EOF_
done;

cat << _EOF_ >> $PREVIEW_CONF
}
};
_EOF_

#.......................................................................

cd /etc/apache2/sites-enabled/ && \
    rm * && \
    rm ../sites-available/* && \
    cp /provision/${SITE_CONF} ../sites-available/ && \
    ln -s ../sites-available/${SITE_CONF}

#.......................................................................

echo_step "Install done."

exit 0