# Author: Scott Willett
# Version: 2015-09-22
#
# Ensures the device has the latest time updated via NTP and the internet

tzutil.exe /s "E. Australia Standard Time"

reg add HKLM\SYSTEM\CurrentControlSet\Services\W32Time\Config /v MaxNegPhaseCorrection /t REG_DWORD /d 0xffffffff /f
reg add HKLM\SYSTEM\CurrentControlSet\Services\W32Time\Config /v MaxPosPhaseCorrection /t REG_DWORD /d 0xffffffff /f

NET STOP 'Windows Time'
NET START 'Windows Time'

w32tm /resync
w32tm /resync
w32tm /resync

