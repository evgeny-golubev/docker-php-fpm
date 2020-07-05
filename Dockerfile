FROM php:7.4.7-fpm-alpine

MAINTAINER Evgeny Golubev <evgeny@golubev.eu>

ENV EXT_DEPS \
  freetype \
  libpng \
  libjpeg-turbo \
  libwebp \
  freetype-dev \
  libpng-dev \
  libjpeg-turbo-dev \
  libwebp-dev \
  imagemagick-dev \
  libmemcached-dev \
  libtool

RUN set -xe; \
  apk --no-cache update && apk --no-cache upgrade \
  && apk add --no-cache $EXT_DEPS \
  && apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
  && docker-php-ext-configure bcmath \
  && docker-php-ext-configure exif \
  && docker-php-ext-configure gd \
    --with-freetype \
    --with-jpeg \
  && pecl install imagick && pecl install redis && pecl install memcached \
  && NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
  && docker-php-ext-install -j${NPROC} bcmath exif gd mysqli pdo pdo_mysql \
  && docker-php-ext-enable bcmath exif gd imagick mysqli pdo pdo_mysql memcached redis \
  && apk add --no-cache --virtual .imagick-runtime-deps imagemagick \
  # Cleanup build deps
  && apk del .build-deps \
  && rm -rf /tmp/* /var/cache/apk/*

RUN mkdir /usr/local/phar \
    && curl -OsSL https://getcomposer.org/composer.phar \
    && mv composer.phar /usr/local/phar