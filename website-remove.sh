#!/usr/bin/env bash

# Run cleanup via cleanup.sh
docker-compose run --rm build bash /var/www/cleanup.sh

# TODO: remove complete mysql.
# docker-compose run --rm mysql rm -rf /var/lib/mysql

# docker-compose stop
docker-compose stop
docker-compose rm -f