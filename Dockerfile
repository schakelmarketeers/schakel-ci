# Docker image specification for use with our CI build systems
#
# Author: Schakel Marketeers
# License: MIT

FROM php:7.2

# system setup
RUN apt-get update && apt-get install -y \
    sqlite \
    zlib1g-dev \
    libicu-dev \
    libmagickwand-dev \
    gnupg \
    libssl-dev \
    libcurl4-openssl-dev \
    pkg-config

# setup php extensions
RUN pecl install imagick \
    && docker-php-ext-enable imagick \
    && docker-php-ext-install zip \
    && docker-php-ext-install curl \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install json \
    && docker-php-ext-install intl

# disable memory limit
RUN echo "memory_limit = -1;" > $PHP_INI_DIR/conf.d/memory_limit.ini

# make composer work as superuser
ENV COMPOSER_ALLOW_SUPERUSER=1

# install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# install npm
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash && apt-get install -y nodejs

# clean this mess up!
RUN apt-get clean

# install yarn
RUN npm install -g yarn
