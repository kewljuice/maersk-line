#!/bin/bash

# docker up
cd docker
docker-compose stop
docker-compose rm -f
docker-compose up -d

# List all container(s)
docker ps -a

