#!/bin/bash
# Restarts the test server
# Requires AMIA_SERVER_DIR environment variable to be set
if [ -z "$AMIA_SERVER_DIR" ]; then
    echo "Error: AMIA_SERVER_DIR environment variable is not set."
    exit 1
fi
pushd "$AMIA_SERVER_DIR" || exit 1
docker compose stop test-server
docker compose rm -f test-server
docker compose up -d
popd || exit