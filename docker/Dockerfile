# FrankenPHP app server on PHP 8.2+: https://frankenphp.dev/
# Note that they currently don't have a way to version lock PHP so be vigilant post-build
FROM dunglas/frankenphp:main

ENV LANG=C.UTF-8
RUN useradd -m zing && \
    mkdir /home/zing/logs /home/zing/dev && \
    chown -R zing: /home/zing
WORKDIR /home/zing/dev

# Really only curl and git are necessary, the other two are just QoL
# libxslt1-dev libpq-dev zip
RUN apt-get update && \
    apt-get install -y neovim zsh curl git

# Once we have curl; install LTS node and then install yarn through npm
RUN curl -sL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get install -y nodejs
RUN npm install --global yarn

# We use this script to install PHP extensions (and composer) seamlessly
# Also dets default php.ini as the development version
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

# Adds Symfony CLI
RUN curl -sS https://get.symfony.com/cli/installer | bash && \
    mv /root/.symfony5/bin/symfony /usr/local/bin/symfony

# Switch user and include oh-my-zsh for better terminal experience
USER zing
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# These are just for documentation. You're able to override these host ports
# to whatever you want, but it is most streamlined if using 80 and 443
EXPOSE 80
EXPOSE 443

# Default zsh instead of bash (although you can still use bash)
CMD ['/usr/local/bin/zsh']