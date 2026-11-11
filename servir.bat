@echo off
chcp 65001 >nul
title PataViva - Servidor Local
cd /d "%~dp0"

echo.
echo  Iniciando o servidor local da PataViva...
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0servidor.ps1" %*

echo.
echo  Servidor encerrado.
pause
