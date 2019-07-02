ARG PHP_TAG="7.3-cli-alpine3.9"

FROM php:$PHP_TAG

ENV COMPOSER_ALLOW_SUPERUSER 1

RUN set -ex \
  	&& apk update \
    && apk add --no-cache --virtual .build-deps curl gcc g++ make build-base autoconf \
    && apk add openssl-dev libuv-dev \
    && docker-php-ext-install sockets pcntl\
    && docker-php-source extract \
    && printf "no\n" | pecl install ev \
    && pecl install uv-0.2.4 \
    && docker-php-ext-enable ev uv \
    && docker-php-source delete \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && apk del .build-deps \
    && rm -rf /tmp/* 