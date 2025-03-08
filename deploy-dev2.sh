#!/bin/bash
pushd /home/amia/dev_server
docker-compose stop devserver2
docker-compose rm -f devserver2
docker-compose up -d
popd
