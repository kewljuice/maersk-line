# Set the base image to PHP
FROM php:7-fpm

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

# Install Drush Dependencies
RUN \
    curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    ln -s /usr/local/bin/composer /usr/bin/composer && \
    git clone --branch master https://github.com/drush-ops/drush/ /usr/local/src/drush && \
    cd /usr/local/src/drush && \
    git checkout 8.x && \
    ln -s /usr/local/src/drush/drush /usr/bin/drush && \
    composer install

# That's all folks