#!/bin/bash
# Restarts the dev server 2
# Requires AMIA_SERVER_DIR environment variable to be set
if [ -z "$AMIA_SERVER_DIR" ]; then
    echo "Error: AMIA_SERVER_DIR environment variable is not set."
    exit 1
fi
pushd "$AMIA_SERVER_DIR" || exit 1
docker compose stop devserver2
docker compose rm -f devserver2
docker compose up -d
popd || exit
