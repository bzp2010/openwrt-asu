#!/bin/sh

# clean temporary files
rm -rf /tmp/storage-run-$(id -u)/containers /tmp/storage-run-$(id -u)/libpod/tmp

# start podman service
SOCK_PATH="/run/podman"

podman system service --time=0 unix:"${SOCK_PATH}/podman.sock" &

# load pre-built images
for f in /tmp/images/*.tgz; do podman load -i "$f"; done

# set environment variables for ASU

echo "PUBLIC_PATH=/asu/public" > /asu/.env
echo "CONTAINER_SOCKET_PATH=${SOCK_PATH}/podman.sock" >> /asu/.env
echo "REDIS_URL=redis://redis:6379/0" >> /asu/.env
echo "ALLOW_DEFAULTS=1" >> /asu/.env

yq e '.services |= with_entries(.value.network_mode = "host")' -i podman-compose.yml
yq e 'del(.services.redis)' -i podman-compose.yml
yq e 'del(.services.server.environment) | del(.services.worker.environment)' -i podman-compose.yml
yq e 'del(.services.server.build) | del(.services.worker.build)' -i podman-compose.yml
yq e 'del(.services.server.ports) | del(.services.worker.ports)' -i podman-compose.yml
yq e 'del(.services.server.depends_on) | del(.services.worker.depends_on)' -i podman-compose.yml

sed -i 's/server:8000/127.0.0.1:8000/g' ./misc/Caddyfile

podman-compose up
