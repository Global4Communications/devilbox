#!/bin/bash
# Mirrors the parts of the devilbox php-fpm entrypoint that the CLI workflow depends on. A failing startup
# script must never stop the container: the upstream entrypoint exits on failure, which is what made
# `docker exec` report "container is not running" when DNS was not ready.

# FORWARD_PORTS_TO_LOCALHOST="80:httpd:80,3306:mysql:3306" makes localhost:<port> reach the named service.
if [ -n "${FORWARD_PORTS_TO_LOCALHOST:-}" ]; then
    IFS=',' read -ra forwards <<< "${FORWARD_PORTS_TO_LOCALHOST}"
    for forward in "${forwards[@]}"; do
        IFS=':' read -r local_port host remote_port <<< "${forward}"
        [ -n "${local_port}" ] && [ -n "${host}" ] && [ -n "${remote_port}" ] || continue
        socat "TCP-LISTEN:${local_port},fork,reuseaddr,bind=127.0.0.1" "TCP:${host}:${remote_port}" &
    done
fi

# Per-version scripts first, then the shared ones, in the same order as the upstream images.
for dir in /startup.1.d /startup.2.d; do
    for script in "${dir}"/*.sh; do
        [ -f "${script}" ] || continue
        echo "startup: running ${script}"
        bash "${script}" || echo "startup: ${script} failed (continuing)"
    done
done

exec "$@"
