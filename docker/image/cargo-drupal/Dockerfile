# Set the base image to PHP
FROM cargo-php

# File Maintainer
MAINTAINER ctrl.be

# Install Drush Dependencies
ENV DRUSH_VERSION 8.1.2
RUN curl -L --silent https://github.com/drush-ops/drush/releases/download/${DRUSH_VERSION}/drush.phar \
  > /usr/local/bin/drush && chmod +x /usr/local/bin/drush

# That's all folks