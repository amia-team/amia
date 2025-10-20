#!/bin/bash

docker run --rm -t -u $(id -u):$(id -g) -v "$(pwd)":/nasher cltalmadge/nasher:amia pack dev

echo "Finished."
