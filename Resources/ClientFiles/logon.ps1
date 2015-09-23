# Author: Scott Willett
# Version: 2015-09-23
#
# Run network logon scripts

# Import the crypto module
Import-Module .\crypto

# Ignore various issues
$ErrorActionPreference = "SilentlyContinue"

# Get credentials from a config file, or request them (from the crypto module)
$credential = GetCredentials

# Map a drive to rt-deploy with the credentials that were grabbed
New-PSDrive -Name "Z" -PSProvider FileSystem -Root "\\rt-deploy\rt-deploy$" -Credential $credential
z:

# Get all the network logon scripts
$files = gci "Scripts\Logon"

# Run them one at a time
foreach ($file in $files)
{
	Invoke-Expression $file.FullName
}

# Change to the c: then remote the mapped drive
c:
Remove-PSDrive -Name "Z"