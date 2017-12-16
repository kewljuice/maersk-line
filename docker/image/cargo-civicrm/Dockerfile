# Set the base image to PHP
FROM cargo-php

# File Maintainer
MAINTAINER ctrl.be

# Install Drush Dependencies
ENV DRUSH_VERSION 8.1.2
RUN curl -L --silent https://github.com/drush-ops/drush/releases/download/${DRUSH_VERSION}/drush.phar \
  > /usr/local/bin/drush && chmod +x /usr/local/bin/drush

# Install Civix Dependencies
RUN curl -LsS --silent https://download.civicrm.org/civix/civix.phar \
    > /usr/local/bin/civix && chmod +x /usr/local/bin/civix

# Install CV Dependencies
RUN curl -LsS https://download.civicrm.org/cv/cv.phar \
    > /usr/local/bin/cv && chmod +x /usr/local/bin/cv

# That's all folks
