#!/bin/sh
set -e
export TZ=UTC

docker run --rm -it \
    --add-host="host.docker.internal:host-gateway" \
    -e OMG_LOCALTESTING_TENANT="omgservers" \
    -e OMG_LOCALTESTING_PROJECT="omgdashturnsgame" \
    -e OMG_LOCALTESTING_STAGE="default" \
    -v ${PWD}/.omgserversctl:/opt/omgservers/.omgserversctl \
    -v ${PWD}/config.json:/opt/omgservers/config.json:ro \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /etc/resolv.conf:/etc/resolv.conf:ro \
    omgservers/ctl:1.0.0-SNAPSHOT $@