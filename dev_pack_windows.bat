PowerShell -NoProfile -ExecutionPolicy Bypass -Command "docker run --rm -t -u ${id -u}:${id -g} -v ${pwd}:/nasher cltalmadge/nasher:amia pack dev --clean --verbose --yes"
echo Finished.
