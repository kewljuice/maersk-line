#!/usr/bin/env bash

#! docker build image(s) to image folder
docker build -t cargo:nginx docker/cargo-nginx/
docker build -t cargo:php docker/cargo-php/