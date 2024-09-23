@echo off
pwd="%~dp0"
CD "%pwd%"
powershell -NoLogo -NoProfile -WindowStyle Hidden -File .\Fix-HotSRez.ps1
