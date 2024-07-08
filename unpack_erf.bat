@echo off
setlocal enabledelayedexpansion

for %%I in (%*) do (
    set "filename=%%~nxI"
    PowerShell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference = 'SilentlyContinue'; docker run --rm -t -u $(id -u):$(id -g) -v ${pwd}:/nasher cltalmadge/nasher:0.20.2 unpack --file !filename! --removeDeleted:false"
)

echo Finished.
pause