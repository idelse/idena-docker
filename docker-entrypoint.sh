#!/bin/sh
set -e

mkdir -p /home/idena/datadir /home/idena/datadir/keystore
echo ${NODE_KEY} > /home/idena/datadir/keystore/nodekey
cd /proxy && npm start
cd /home/idena

# first arg is empty or an argument `-c` or `--some-option`
if [ -z "$1" -o "${1#-}" != "$1" ]; then
	set -- ${BUILD_TARGET} "$@"
fi

# allow the container to be started with `--user`
if [ "$1" = '${BUILD_TARGET}' -a "$(id -u)" = '0' ]; then
	chown ${USER} /data
	exec su-exec ${USER} "$0" "$@"
fi

exec "$@"