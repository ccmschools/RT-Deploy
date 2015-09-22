# Author: Scott Willett
# Version: 2015-09-22
#
# Apply a captured local GPO policy to the machine

$Path = "..\..\Resources\GPOs" 					# Where the captured GPO lives
$Target = "C:\Windows\System32\GroupPolicy"		# Where the GPO will be copied to
# Security policy GPO files
$SecurityInfPath = "C:\Windows\System32\GroupPolicy\security.inf"
$SecuritySdbPath = "C:\Windows\System32\GroupPolicy\secedit.sdb"

# Copying policy settings to the device.
xcopy $Path\*.* $Target\*.* /s /d /h /r /y

# Configuring security policy on the device.
secedit /configure /db $SecuritySdbPath /cfg $SecurityInfPath

# Enabling and starting the Group Policy service.
Set-Service -Name gpsvc -StartupType auto
Start-Service -Name gpsvc

# Updating Group Policy on the device.
gpupdate /force