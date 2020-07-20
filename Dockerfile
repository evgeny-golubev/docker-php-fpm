FROM php:7.4.8-fpm-alpine

MAINTAINER Evgeny Golubev <evgeny@golubev.eu>

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

# PHP Extensions Installer
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/

RUN set -xe; \
  apk --no-cache update && apk --no-cache upgrade \
  && apk add --no-cache git openssh

# PHP Extensions
RUN install-php-extensions mcrypt redis memcached bcmath exif gd gettext mysqli pdo_mysql zip pcntl soap yaml mongodb

# Cleanup build deps
RUN rm -rf /tmp/* /var/lib/apt/lists/* /var/cache/apk/*