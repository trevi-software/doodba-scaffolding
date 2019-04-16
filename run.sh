#!/bin/sh
#

ln -s devel.yaml docker-compose.yml
chown -R $USER:1000 odoo/auto
chmod -R ug+rwX odoo/auto
export UID GID="$(id -g $USER)" UMASK="$(umask)"
docker-compose build --pull
docker-compose -f setup-devel.yaml run --rm odoo
docker-compose up
