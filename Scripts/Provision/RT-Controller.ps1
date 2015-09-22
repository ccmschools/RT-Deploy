# Author: Scott Willett
# Version: 2015-09-22
#
# Controls the entire logic for RT-Deploy

# Bypass any warnings / restrictions on running powershell scripts indefinitely
Set-ExecutionPolicy Bypass -Force

#! Ensure the device has the correct time (through the internet)
Invoke-Expression ".\RT-SetTime.ps1"

#! Copy required files onto the local device from the ClientFiles directory
Invoke-Expression ".\RT-CopyFiles.ps1"

#! Create an admin user account
Invoke-Expression ".\RT-CreateAdmin.ps1"

#! Add our trusted root certificates
Invoke-Expression ".\RT-AddCertificates.ps1"

#! Change the computer name, create a user based off the computer name with a password and email the concierge desk
Invoke-Expression ".\RT-ChangeNames.ps1"

#! Apply some local group policies
Invoke-Expression ".\RT-ApplyGPO.ps1"

# Seal the image with OOBE
Invoke-Expression ".\RT-PrepareSysprep.ps1"