#!/usr/bin/env bash

# Build docker image(s) to image folder
docker build -t cargo:php       docker/cargo-php/
docker build -t cargo:drupal    docker/cargo-drupal/