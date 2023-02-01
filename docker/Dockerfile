# FrankenPHP app server on PHP 8.2+: https://frankenphp.dev/
# Note that they currently don't have a way to version lock PHP so be vigilant post-build
FROM dunglas/frankenphp:main

ARG APP_INIT
ARG GIT_USER_NAME
ARG GIT_USER_EMAIL
ENV LANG=C.UTF-8
RUN useradd -m chill && \
    mkdir /home/chill/logs && \
    chown -R chill: /home/chill

# Libnss3-tools for certutil (aka TLS support)
RUN apt-get update && \
    apt-get install -y vim-tiny curl git libnss3-tools

# Once we have curl; install LTS node and then install yarn through npm
RUN curl -sL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get install -y nodejs
RUN npm install --global yarn

# We use this script to install PHP extensions (and composer) seamlessly
# Also sets default php.ini as the development version
RUN curl -sSLf \
        -o /usr/local/bin/install-php-extensions \
        https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions && \
    chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions xdebug zip intl xsl redis solr pgsql pdo-pgsql @composer && \
    mv /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini

# Copy xdebug settings and PHP.ini overrides into container's shared ini directory
COPY ./.build/php-ini/ /usr/local/etc/php/conf.d/

# Copy Mailhog Sendmail Binary
COPY ./.build/bin/mhsendmail_linux_amd64 /usr/local/bin/mhsendmail

# Copy symfony-init script to enable optional initialization of a new symfony project
COPY .build/symfony-init.sh /home/chill/symfony-init.sh
RUN chmod +x /home/chill/symfony-init.sh

# Adds Symfony CLI
RUN curl -sS https://get.symfony.com/cli/installer | bash && \
    mv /root/.symfony5/bin/symfony /usr/local/bin/symfony

# Switch user
USER chill
# If APP_INIT env set to 'init', then create a new Symfony application,
# else make the directory that an existing project will populate
RUN /home/chill/symfony-init.sh $APP_INIT $GIT_USER_NAME $GIT_USER_EMAIL

# In either case, this ends up being the work directory
WORKDIR /home/chill/dev

# These are just for documentation. You're able to override these host ports
# to whatever you want, but it is most streamlined if using 80 and 443
EXPOSE 80
EXPOSE 443
