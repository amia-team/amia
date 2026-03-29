#!/bin/bash
# Restarts the dev server
# Uses DEV_SERVER_BASE by default; falls back to AMIA_SERVER_DIR for compatibility
base_dir="${DEV_SERVER_BASE:-${AMIA_SERVER_DIR}}"
if [ -z "$base_dir" ]; then
    echo "Error: DEV_SERVER_BASE or AMIA_SERVER_DIR environment variable is not set."
    exit 1
fi
# dev server compose lives one level under module root in this repo convention
server_dir="$base_dir/dev_server"
if [ ! -d "$server_dir" ]; then
    echo "Error: server directory '$server_dir' does not exist."
    exit 1
fi
pushd "$server_dir" || exit 1
docker compose stop dev-server
docker compose rm -f dev-server
docker compose up -d
popd || exit