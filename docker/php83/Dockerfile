# syntax=docker/dockerfile:1.7
#
# Lean PHP 8.3 service for devilbox. The upstream devilbox/php-fpm images stop at PHP 8.2 (last published
# 2023-02-03), so this reproduces only what the CLI workflow relies on: the `devilbox` user at the host
# uid/gid so files written through the /shared/httpd bind mount keep the right owner, Composer, git and
# the mounted SSH key for the private repos, the extensions the packages and PHPUnit need, the mounted
# startup/bashrc directories, and the localhost port forwards. It does not include the Microsoft ODBC
# driver, sqlsrv, Xdebug or mail catching.

FROM php:8.3-fpm-bookworm

ARG NEW_UID=1000
ARG NEW_GID=1000

COPY --from=mlocati/php-extension-installer:2 /usr/bin/install-php-extensions /usr/local/bin/
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        openssh-client \
        procps \
        socat \
        unzip \
    && rm -rf /var/lib/apt/lists/* \
    && install-php-extensions bcmath exif gd intl mysqli pcntl pdo_mysql sockets zip \
    && groupadd --gid "${NEW_GID}" devilbox \
    && useradd --create-home --uid "${NEW_UID}" --gid "${NEW_GID}" --shell /bin/bash devilbox \
    && mkdir -p /home/devilbox/.composer /etc/php-custom.d \
    && chown -R devilbox:devilbox /home/devilbox \
    && printf 'memory_limit = 1G\ndate.timezone = UTC\n' > /usr/local/etc/php/conf.d/zz-devilbox.ini \
    && printf '\nfor f in /etc/bashrc-devilbox.d/*.sh; do [ -f "$f" ] && . "$f"; done\n' >> /etc/bash.bashrc

# A leading colon keeps PHP's default scan directory and adds the mounted php-ini directory after it.
ENV PHP_INI_SCAN_DIR=":/etc/php-custom.d" \
    COMPOSER_HOME=/home/devilbox/.composer \
    PATH="/home/devilbox/.composer/vendor/bin:${PATH}"

COPY entrypoint.sh /usr/local/bin/devilbox-entrypoint
RUN chmod +x /usr/local/bin/devilbox-entrypoint

ENTRYPOINT ["devilbox-entrypoint"]
CMD ["php-fpm"]
