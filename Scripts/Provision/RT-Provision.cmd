REM :: Author: Scott Willett
REM :: Version: 2015-09-22
REM ::
REM :: Use this file to provision your Surface RT

@echo off

net use z: \\rt-deploy\rt-deploy$
z:
cd "Scripts\Provision"

powershell.exe -ExecutionPolicy Bypass .\RT-Controller.ps1

c:
net use z: /DELETE /YES

shutdown /r /f /t 0