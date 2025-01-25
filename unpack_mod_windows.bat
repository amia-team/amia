PowerShell -NoProfile -ExecutionPolicy Bypass -Command "docker run --rm -t -u ${id -u}:${id -g} -v ${pwd}:/nasher cltalmadge/nasher:1.1.1 unpack --file Amia.mod --default"
echo Finished.