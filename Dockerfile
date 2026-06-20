FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Jakarta

# Install dependencies and add Ondrej PPA for PHP 8.4
RUN apt-get update && apt-get install -y software-properties-common curl wget unzip gettext-base \
    && add-apt-repository ppa:ondrej/php -y \
    && apt-get update \
    && apt-get install -y \
    apache2 \
    php8.4 \
    php8.4-cli \
    php8.4-common \
    php8.4-mysql \
    php8.4-zip \
    php8.4-gd \
    php8.4-mbstring \
    php8.4-curl \
    php8.4-xml \
    php8.4-intl \
    php8.4-exif \
    php8.4-tidy \
    libapache2-mod-php8.4 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install IonCube Loader 15
RUN cd /tmp \
    && wget https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz \
    && tar -zxvf ioncube_loaders_lin_x86-64.tar.gz \
    && cp ioncube/ioncube_loader_lin_8.4.so /usr/lib/php/20240924/ \
    && echo "zend_extension=/usr/lib/php/20240924/ioncube_loader_lin_8.4.so" > /etc/php/8.4/apache2/conf.d/00-ioncube.ini \
    && echo "zend_extension=/usr/lib/php/20240924/ioncube_loader_lin_8.4.so" > /etc/php/8.4/cli/conf.d/00-ioncube.ini \
    && rm -rf /tmp/ioncube*

# Enable Apache mods
RUN a2enmod rewrite ssl headers php8.4

# Setup entrypoint and configs
COPY apache/opensid.conf.template /etc/apache2/sites-available/opensid.conf.template
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh \
    && a2dissite 000-default.conf \
    && a2ensite opensid.conf

WORKDIR /var/www/html

EXPOSE 80 443

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["apache2ctl", "-D", "FOREGROUND"]
