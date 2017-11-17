# Set the base image to PHP
FROM cargo-drupal

# File Maintainer
MAINTAINER ctrl.be

# Install Civix Dependencies
RUN curl -LsS --silent https://download.civicrm.org/civix/civix.phar \
    > /usr/local/bin/civix && chmod +x /usr/local/bin/civix

# That's all folks