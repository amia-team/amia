#!/bin/bash
pushd /home/amia/amia_server
docker-compose stop test-server
docker-compose rm -f test-server
docker-compose up -d
popd