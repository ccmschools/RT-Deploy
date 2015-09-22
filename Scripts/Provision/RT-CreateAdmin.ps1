# Author: Scott Willett
# Version: 2015-09-22
#
# Creates a local admin user that can be used by IT for various tasks

# Get data from the config file
$config = get-content .\settings.config | convertfrom-stringdata

# Create the user from the config file
net user /add $config.admin_user $config.admin_password

# Add the user to the local administrators group
net localgroup administrators $config.admin_user /add