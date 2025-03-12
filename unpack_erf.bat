@echo off
setlocal enabledelayedexpansion

for %%I in (%*) do (
    set "filename=%%~nxI"
    PowerShell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference = 'SilentlyContinue'; docker run --rm -t -u $(id -u):$(id -g) -v ${pwd}:/nasher cltalmadge/nasher:amia unpack --file !filename! --removeDeleted:false"
)

echo Finished.
pause