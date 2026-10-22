# PHP 8.3 ini directory

* Add your custom php.ini files into this directory.
* Only files ending by `.ini` are enabled. They are not ignored by git, so commit only settings the whole
  team should share.
* This directory is mounted at `/etc/php-custom.d` and added to `PHP_INI_SCAN_DIR` after PHP's default
  directory, so it overrides the image defaults (`memory_limit = 1G`, `date.timezone = UTC`).
* If several `.ini` files set the same value, the last one by filename wins.

The PHP 8.3 container is built from `docker/php83` (upstream devilbox publishes no PHP 8.3 image), so there
are no `devilbox-php.ini-*` example files here.
