#!/bin/bash

# Check docker and list image(s)
docker --version
docker images

# Check docker compose and list container(s)
docker-compose --version
docker ps -a

# Check docker-machine
docker-machine --version
docker-machine ls
