#!/bin/bash
for arg in "$@"; do
    filename=$(basename "$arg")
    docker run --rm -t \
        -u $(id -u):$(id -g) \
        -v "$PWD":/nasher \
        cltalmadge/nasher:amia unpack --file "$filename" --removeDeleted:false --yes
done

echo "Finished."

read -p "Press [Enter] key to continue..."

