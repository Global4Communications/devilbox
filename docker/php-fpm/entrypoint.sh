#!/bin/bash
set -e

if [ -f /ca/devilbox-ca.crt ]; then
    cp /ca/devilbox-ca.crt /usr/local/share/ca-certificates/devilbox-ca.crt
    update-ca-certificates >/dev/null
fi

IFS=',' read -ra forwards <<< "${FORWARD_PORTS_TO_LOCALHOST:-}"
for forward in "${forwards[@]}"; do
    IFS=':' read -r local_port host remote_port <<< "$forward"
    socat "TCP-LISTEN:${local_port},bind=127.0.0.1,fork,reuseaddr" "TCP:${host}:${remote_port}" &
done

for dir in /startup.1.d /startup.2.d; do
    for script in "$dir"/*.sh; do
        [ -f "$script" ] && bash "$script" || true
    done
done

exec docker-php-entrypoint "$@"
