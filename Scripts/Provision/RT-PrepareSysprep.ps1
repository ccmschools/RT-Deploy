# Author: Scott Willett
# Version: 2015-09-22
#
# Prepares the device for sysprep upon the next boot and makes some edits to the unattend.xml file too

# Get data from the config file
$config = get-content .\settings.config | convertfrom-stringdata

$ScriptPath = "..\..\Resources\Sysprep"					# Network unattend path
$TargetPath = "C:\Windows\Panther"						# Local unattend path
$SaveUnattendFile = "Unattend.sav"						# What the unattend file will be renamed to in this script later on
$RunOnceSource = "$($ScriptPath)\RT-RunSysprep.ps1"		# Script that will run sysprep after restart. The network version
$RunOnceTarget = "$($TargetPath)\RT-RunSysprep.ps1"		# The script above will be copied from that location to this location
$SourceUnattendFile = "$($ScriptPath)\Unattend.xml"		# The network unattend file
$TargetUnattendFile = "$($TargetPath)\Unattend.xml"		# The local unattend file

if (Test-Path $SourceUnattendFile ) {
	Copy-Item $SourceUnattendFile $TargetUnattendFile	# Copy the network unattend.xml file to the panther directory where it will be run upon sysprep
	if (Test-Path $TargetUnattendFile ) {
		# Grab the data from the "RT-ChangeNames.ps1" script with computer_name and password details and inject some variables into the unattend file
		$json = get-content -raw "$($config.local_path)\sysprep.json"
		$json = $json | convertfrom-json
		(gc $TargetUnattendFile) -replace '{{computer_name}}', $json.computer_name | out-file $TargetUnattendFile
		(gc $TargetUnattendFile) -replace '{{password}}', $json.password | out-file $TargetUnattendFile
		# Rename the panther unattend.xml file as unattend.sav
		Rename-Item $TargetUnattendFile $SaveUnattendFile
	}
}

# Prepare the Windows RT device to run RT-RunSysprep.ps1 the
# next time the device starts. We use the RunOnce registry key.
Write-Output "Preparing the device to restart."
Copy-Item $RunOnceSource $RunOnceTarget
New-ItemProperty `
	-Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce `
	-Name Sysprep `
	-Value "powershell.exe -ExecutionPolicy Bypass $RunOnceTarget"