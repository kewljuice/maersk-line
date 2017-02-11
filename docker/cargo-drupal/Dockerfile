# Set the base image to PHP
FROM php:7-fpm

# File Maintainer
MAINTAINER ctrl.be

# Install Dependencies
RUN \
 apt-get update && \
 apt-get install -y \
 curl \
 cron \
 nano \
 git \
 mysql-client \
 unzip

# Install Drush Dependencies
RUN \
    curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    ln -s /usr/local/bin/composer /usr/bin/composer && \
    git clone --branch master https://github.com/drush-ops/drush/ /usr/local/src/drush && \
    cd /usr/local/src/drush && \
    ln -s /usr/local/src/drush/drush /usr/bin/drush && \
    composer install

# That's all folks