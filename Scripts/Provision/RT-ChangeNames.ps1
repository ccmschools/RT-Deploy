# Author: Scott Willett
# Version: 2015-09-22
#
# Generate a computer name baseed of the device serial, and a 4 digit password / PIN and apply them, then save the data to a file for use later on in the JSON format

# Get data from the config file
$config = get-content .\settings.config | convertfrom-stringdata

# Get the Surfaces serial and compile the computer name
$serial = wmic bios get serialnumber
$computer_name = "RT-$($serial[2])".Trim()

# Rename the computer based off the strings above
Rename-Computer -NewName $computer_name

# Generate a random 4 digit pin / password
$password = Get-Random
$password = $password.ToString().Trim().Substring(0, 4)

# Create a user based off the computer name with a 4 digit pin
net user /add $computer_name $password
net localgroup administrators $computer_name /add

# Send an email to the concierge desk with the details to create a label for the device
Send-MailMessage -SmtpServer "$($config.smtp_server)" -To "$($config.to_address)" -Subject "Surface Provisioned: $($computer_name)" -From "$($config.from_address)" -Body "$($computer_name)`n$($password)"

# Place the computername and password info into a hash table, convert it to json, and place it in a file to be used in other scripts
$object = @{"computer_name"=$computer_name; "password"=$password}
$object | ConvertTo-JSON > "$($config.local_path)\sysprep.json"