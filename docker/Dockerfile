# FrankenPHP app server on PHP 8.2+: https://frankenphp.dev/
# Note that they currently don't have a way to version lock PHP so be vigilant post-build
FROM dunglas/frankenphp:main

ENV LANG=C.UTF-8
RUN useradd -m zing && mkdir /home/zing/logs /home/zing/dev && chown -R zing: /home/zing
WORKDIR /home/zing/dev

# Base dependencies; curl for Node, libs for PHP extension dependencies; git zip for Composer; xdebug for debugging
RUN apt-get update && apt-get install -y neovim zsh curl libxslt1-dev libpq-dev git zip
# TODO PHP 8.2 breaks PECL
# RUN pecl install xdebug

# Once we have curl; install LTS node and then install yarn through npm
RUN curl -sL https://deb.nodesource.com/setup_lts.x | bash - && apt-get install -y nodejs
RUN npm install --global yarn

# Necessary PHP extensions (at least for a small Symfony project), most notably Postgresql driver
# TODO get FrankenPHP to support 8.1 for PECL
#RUN docker-php-ext-enable xdebug
RUN docker-php-ext-install xsl
RUN docker-php-ext-install intl
RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_pgsql pgsql \
    && docker-php-ext-enable pdo_pgsql

# Set php.ini-development as container's php.ini file
RUN mv /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini

# Copy xdebug settings and PHP.ini overrides into container's shared ini directory
COPY ./.build/php-ini/xdebug.ini /usr/local/etc/php/conf.d/
COPY ./.build/php-ini/php-ini-overrides.ini /usr/local/etc/php/conf.d/

# Add Mailhog Sendmail Binary
COPY ./.build/bin/mhsendmail_linux_amd64 /usr/local/bin/mhsendmail

# Composer and symfony binaries
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN curl -sS https://get.symfony.com/cli/installer | bash
RUN mv /root/.symfony5/bin/symfony /usr/local/bin/symfony

# Switch user and include oh-my-zsh for better terminal experience
USER zing
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# These are just for documentation. You're able to override these host ports
# to whatever you want, but it is most streamlined if using 80 and 443
EXPOSE 80
EXPOSE 443

# Default zsh instead of bash (although you can still use bash))
CMD ['/usr/local/bin/zsh']