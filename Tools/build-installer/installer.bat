@echo off
setlocal

pushd %~dp0
call npm ci
if errorlevel 1 goto :error
call npm run build-installer
if errorlevel 1 goto :error

popd
pause
exit /b 0

:error
popd
echo.
echo Installer build failed.
pause
exit /b 1
