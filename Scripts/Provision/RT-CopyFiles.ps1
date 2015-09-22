# Author: Scott Willett
# Version: 2015-09-22
#
# Copies files in the RT-Deploy resources directory to the local system. Does it via a loop as the loop originally contained extra logic

# Get data from the config file
$config = get-content .\settings.config | convertfrom-stringdata

$ErrorActionPreference = "SilentlyContinue"

MKDIR $config.local_path

$files = gci "..\..\Resources\ClientFiles"

foreach ($file in $files)
{
	Copy-Item $file.FullName $config.local_path -Force
}
