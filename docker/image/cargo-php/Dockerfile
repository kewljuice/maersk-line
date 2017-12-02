# Set the base image to PHP
FROM php:7.0-fpm

# File Maintainer
MAINTAINER ctrl.be

# Install Dependencies
RUN \
 apt-get update && apt-get install -y \
 git \
 curl \
 cron \
 nano \
 unzip \
 mysql-client \
 libfreetype6-dev \
 libjpeg62-turbo-dev \
 libmcrypt-dev \
 libpng12-dev

# Install PHP Dependencies
RUN docker-php-ext-install opcache pdo pdo_mysql mysqli

RUN docker-php-ext-install -j$(nproc) iconv mcrypt
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install -j$(nproc) gd

# That's all folks
