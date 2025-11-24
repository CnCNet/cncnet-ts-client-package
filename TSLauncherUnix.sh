#!/bin/sh

cd "$(dirname "$0")"

# Set an alternative Wine
export WINE=wine

# This isolates Wine configurations for this application
export WINEPREFIX=${PWD}/wineprefix/

# Set win10 windows version for game.exe
${WINE:=wine} reg add HKEY_CURRENT_USER\\Software\\Wine\\AppDefaults\\game.exe /v Version /d win10 /f

# Set native,builtin for ddraw override option for game.exe
${WINE:=wine} reg add HKEY_CURRENT_USER\\Software\\Wine\\AppDefaults\\game.exe\\DllOverrides /v ddraw /d native,builtin /f

chmod +x wine-ts.sh

dotnet Resources/BinariesNET8/UniversalGL/clientogl.dll "$@"
