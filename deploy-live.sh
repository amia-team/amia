#!/bin/bash
pushd /home/amia/amia_server
docker compose stop nwserver
docker compose rm -f nwserver
docker compose up -d
popd