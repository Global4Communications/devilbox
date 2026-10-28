ARG PHP_VERSION=8.3
FROM php:${PHP_VERSION}-fpm

COPY --from=mlocati/php-extension-installer:2 /usr/bin/install-php-extensions /usr/local/bin/
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates curl git less mariadb-client socat sudo unzip vim-tiny \
    && rm -rf /var/lib/apt/lists/* \
    && install-php-extensions \
        amqp apcu bcmath bz2 calendar exif gd gmp igbinary imagick intl \
        memcached mysqli opcache pcntl pdo_mysql pdo_pgsql pdo_sqlsrv pgsql redis \
        soap sockets sqlsrv tidy uuid xdebug xsl yaml zip

RUN groupadd -g 1000 devilbox \
    && useradd -m -u 1000 -g 1000 -s /bin/bash devilbox \
    && echo 'devilbox ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/devilbox \
    && sed -i 's/^user = www-data/user = devilbox/; s/^group = www-data/group = devilbox/' /usr/local/etc/php-fpm.d/www.conf \
    && echo 'include=/etc/php-fpm-custom.d/*.conf' >> /usr/local/etc/php-fpm.conf \
    && printf 'for f in /etc/bashrc-devilbox.d/*.sh; do [ -r "$f" ] && . "$f"; done\n' >> /etc/bash.bashrc

ENV PHP_INI_SCAN_DIR=":/etc/php-custom.d" \
    COMPOSER_HOME=/home/devilbox/.composer

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["php-fpm"]
