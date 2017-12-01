#!/bin/bash

# Docker-Compose up
docker-compose up -d

# Run installer once via generate.sh
docker-compose run --rm build bash /var/www/generate.sh

# List all container(s)
docker ps -a
