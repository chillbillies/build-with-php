FROM php:8.1.12-fpm-bullseye

# Base dependencies; curl for Node, libs for PHP extension dependencies; git zip for Composer; xdebug for debugging
RUN apt-get update && apt-get install -y curl libxslt1-dev libpq-dev git zip
RUN pecl install xdebug

# Once we have curl; install LTS node and then install yarn through npm
RUN curl -sL https://deb.nodesource.com/setup_lts.x | bash - && apt-get install -y nodejs
RUN npm install --global yarn

# Necessary PHP extensions, most notably Postgresql driver
RUN docker-php-ext-enable xdebug
RUN docker-php-ext-install xsl
RUN docker-php-ext-install intl
RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_pgsql pgsql \
    && docker-php-ext-enable pdo_pgsql

# Set php.ini-development as container's php.ini file
RUN mv /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini

# Copy xdebug settings and PHP.ini overrides into container's shared ini directory
COPY ./php-ini/xdebug.ini /usr/local/etc/php/conf.d/
COPY ./php-ini/php-ini-overrides.ini /usr/local/etc/php/conf.d/

# Composer and symfony binaries
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN curl -sS https://get.symfony.com/cli/installer | bash
RUN mv /root/.symfony5/bin/symfony /usr/local/bin/symfony

# Non-root project user
RUN useradd -m zing
USER zing
WORKDIR /var/www/html/zing

# Ports used within container
EXPOSE 80 # http
EXPOSE 443 # https (untested)
EXPOSE 5432 # postgres
EXPOSE 9000 # php-fpm
EXPOSE 9003 # xdebug
