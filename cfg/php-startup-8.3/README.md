# Custom startup scripts (for PHP 8.3 only)

Any script inside this directory ending by `.sh` is executed during the PHP container startup, before the
shared scripts in `autostart/`. A script that fails is reported in the container log and the container still
starts.

A example is given that does not end by `.sh` and so is not run. To use it, copy it to a file ending by `.sh`.

## Note

This directory runs commands for PHP 8.3 only. To run commands for all versions, use `autostart/` in the root
of the Devilbox git directory.

## Important

All scripts are executed with **root** permissions.
