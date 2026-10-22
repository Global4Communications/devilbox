# PHP-FPM 8.3 configuration directory

This directory is mounted at `/etc/php-fpm-custom.d` to match the other PHP services, but the lean PHP 8.3
container (built from `docker/php83`) does not read it yet. Pool settings come from the official image's
defaults (`listen = 9000`).
