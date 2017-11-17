#!/bin/bash

# Docker-Compose up
docker-compose stop
docker-compose rm -f
docker-compose up -d

# List all container(s)
docker ps -a
