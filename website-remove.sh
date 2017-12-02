#!/usr/bin/env bash

# Run cleanup via cleanup.sh
docker-compose run --rm build bash /var/www/cleanup.sh
