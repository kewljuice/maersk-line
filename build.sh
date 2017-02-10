#!/usr/bin/env bash

# Build docker image(s) to image folder
docker build -t cargo:nginx docker/cargo-nginx/
docker build -t cargo:php docker/cargo-php/