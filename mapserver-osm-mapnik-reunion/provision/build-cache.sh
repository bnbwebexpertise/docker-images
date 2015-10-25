#!/bin/sh

for tile in osm grayscale osmbright osmlight osmstreets; do
    perl /provision/render_list-rect.pl 11 1337 1341 1145 1148 10 19 -n 2 -t /var/lib/mod_tile -m $tile;
done