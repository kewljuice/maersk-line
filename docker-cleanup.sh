#!/usr/bin/env bash

# Delete all containers
docker rm -f $(docker ps -a -q)

# Delete all images
docker rmi $(docker images -q)

# Delete all untagged images
# docker rmi $(docker images | grep "^<none>" | awk "{print $3}")

# Unset docker env
#unset ${!DOCKER_*}