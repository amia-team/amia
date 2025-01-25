PowerShell -NoProfile -ExecutionPolicy Bypass -Command "docker run --rm -t -u ${id -u}:${id -g} -v ${pwd}:/nasher cltalmadge/nasher:0.20.2 unpack --file Amia.mod --default"
echo Finished.