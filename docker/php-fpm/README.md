# php-fpm

One Dockerfile for every devilbox PHP service that devilbox no longer publishes (8.3+).
The PHP version is a build arg.

## Add a new version (e.g. 8.6)

1. Copy `cfg/php-{ini,fpm,startup}-8.5` to `-8.6`, `mkdir log/php-fpm-8.6`.
2. Add `/log/php-fpm-8.6/*` to `.gitignore`.
3. Copy the `php85` service in `docker-compose.override.yml`. Change:
   - `args.PHP_VERSION` to `8.6`
   - `image` to `devilbox-php86:local`
   - `hostname`, the `8.5` cfg/log paths and the next free `ipv4_address`
4. `docker compose build php86 && docker compose up -d --no-deps php86`
5. Point a project at it with `.devilbox/backend.cfg`: `conf:phpfpm:tcp:php86:9000`, then `docker compose restart httpd`.

If an extension has no release for the new PHP yet, the build fails at `install-php-extensions`.
Drop it from the list until upstream catches up.
