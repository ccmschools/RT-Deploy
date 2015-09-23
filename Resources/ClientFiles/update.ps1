# Author: Scott Willett
# Version: 2015-09-23
#
# Updates local client files from the RT-Deploy path

# Import the crypto module
Import-Module .\crypto

# Ignore various issues
$ErrorActionPreference = "SilentlyContinue"

# Get credentials from a config file, or request them (from the crypto module)
$credential = GetCredentials

# Map a drive to rt-deploy with the credentials that were grabbed
New-PSDrive -Name "Z" -PSProvider FileSystem -Root "\\rt-deploy\rt-deploy$" -Credential $credential
z:

# The local files to be updated
$client_path = "$($ENV:ProgramData)\RT-Deploy"

# Create the directory in the rare chance it doesn't exist
MKDIR $client_path

# Get the server files
$files = gci "Resources\ClientFiles"

# Copy theme over (in a loop as logic may be added later)
foreach ($file in $files)
{
	Copy-Item $file.FullName $client_path -Force
}

# Change to the c: then remote the mapped drive
c:
Remove-PSDrive -Name "Z"