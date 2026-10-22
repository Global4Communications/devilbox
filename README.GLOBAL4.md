# 🚀 Global4 README

## Setup

Add this to .bashrc / .zshrc

```sh
export IP=$(hostname -I)
```

## PHP 8.3 container (`php83`)

Upstream devilbox does not publish a PHP 8.3 image (its `devilbox/php-fpm` images stop at 8.2), so `php83` is
built from [`docker/php83`](docker/php83) on the official `php:8.3-fpm` image. It is meant for the CLI
workflow (Composer, PHPUnit, PHPStan, phpcs) of the packages that require PHP `^8.3`.

```sh
docker compose up -d php83          # builds the image on first use (about 2 minutes), then starts it
docker exec -u devilbox -w /shared/httpd/<repo> devilbox-php83-1 vendor/bin/phpunit
```

Start it with the other services, after `bind`, so the startup scripts can resolve hosts. Unlike the upstream
images, a failing startup script is logged and the container keeps running.

What matches the other PHP services: the `devilbox` user at `NEW_UID`/`NEW_GID` (files written through
`/shared/httpd` keep the right owner), the mounted SSH key for the private repositories, the `autostart/` and
per-version `cfg/php-startup-8.3` scripts, the `bash/` hooks, `localhost` port forwards to `mysql`, `httpd` and
the others, and the fixed address `172.16.238.212`.

What it does not have: the Microsoft ODBC driver and `sqlsrv`, Xdebug, mail catching, and the PHP-FPM custom
configuration directory (mounted but not read). Add anything needed to `docker/php83/Dockerfile`.

To move to another version, change the `FROM` tag, add a `php8x` service with the next free address, and add
the matching `cfg/`, `log/` and `.gitignore` entries.
