#!/bin/bash

echo 'Installing phpcompatibility/php-compatibility'
su -c 'composer global require phpcompatibility/php-compatibility --dev --no-interaction' -l devilbox

echo 'Adding standard to phpcs'
su -c '/home/devilbox/.composer/vendor/bin/phpcs --config-set installed_paths /home/devilbox/.composer/vendor/phpcompatibility/php-compatibility' -l devilbox
