FROM php:8.1-apache

RUN a2enmod rewrite ssl headers

RUN apt-get update && apt-get install -y \
    libzip-dev zip unzip \
    libpng-dev libjpeg-dev libfreetype6-dev \
    libxml2-dev libonig-dev libicu-dev \
    libcurl4-openssl-dev \
    libtidy-dev tidy \
    git \
 && docker-php-ext-configure gd --with-freetype --with-jpeg \
 && docker-php-ext-install \
    mysqli pdo pdo_mysql mbstring zip gd intl xml curl exif tidy \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

COPY apache/opensid.conf /etc/apache2/sites-available/opensid.conf

RUN a2dissite 000-default.conf \
 && a2ensite opensid.conf

WORKDIR /var/www/html
