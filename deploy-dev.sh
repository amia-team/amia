#!/bin/bash
pushd /home/amia/dev_server
docker compose stop devserver
docker compose rm -f devserver
docker compose up -d
popd