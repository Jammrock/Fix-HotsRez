@echo off
pwd="%~dp0"
CD "%pwd%"
powershell -NoLogo -NoProfile -WindowStyle Hidden -ExecutionPolicy RemoteSigned -File .\Fix-HotSRez.ps1
