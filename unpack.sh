#!/bin/bash

for file in "$@"; do
    filename=$(basename "$file")
    docker run --rm -t -u $(id -u):$(id -g) -v "$(pwd)":/nasher cltalmadge/nasher:amia unpack --file "$filename" --removeDeleted:false --yes
done

echo "Finished."
