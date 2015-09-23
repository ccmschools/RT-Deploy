# Author: Scott Willett
# Version: 2015-09-23
#
# Modules involving encrypting credentials and storing them securely.
# Powershell SecureStrings can only be decrypted on the same machine and account they were encrypted on.

# Request credentials from the user, convert them to JSON format, and store them in a .json file
# Will only do this if the credentials are valid, and will keep asking until they're valid or the user cancels
function RequestCredentials ()
{
	# Flag to indicate if the credentials are valid or not
	$not_valid = $true
	
	# Request credentials until they're valid, then write them to a file
	while ($not_valid)
	{
		# Gets the credentials from the user
		$credential = Get-Credential -Message "Please input your Groves domain username and password"

		if ($credential -eq $null) { break }
		
		# If the credentials authenticate successfully with the domain
		if (TestCredentials($credential))
		{
			# Input the data into a hash table with the values in powershell secure strings in plain text
			$user_config = @{
				"username" = ($credential.username | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString);
				"password" = ($credential.password | ConvertFrom-SecureString)
			}

			# Output the object as JSON to a settings file
			$user_config | ConvertTo-JSON | Out-File "user_config.json"
			
			# The credentials are now valid
			$not_valid = $false
		}
	}

}

# Draw in username and password data from a JSON file and return a PS-Credential object
function GetCredentials ()
{

	# Draw JSON content in from a settings file
	$settings = Get-Content -Raw "user_config.json" | ConvertFrom-JSON
	
	# Construct the PS-Credential object from the above data
	$credential = New-Object -typename System.Management.Automation.PSCredential -argumentlist (DecryptSecureString($settings.username)), ($settings.password | ConvertTo-SecureString)
	
	# Return the PS-Credential object
	return $credential
}

# Decrypt a powershell securestring
# $secure_string = Powershell secure string in plain text
# Code adapted from: http://blogs.msdn.com/b/besidethepoint/archive/2010/09/21/decrypt-secure-strings-in-powershell.aspx
function DecryptSecureString ($secure_string)
{
	$secure_string = $secure_string | ConvertTo-SecureString
	$marshal = [System.Runtime.InteropServices.Marshal]
	$ptr = $marshal::SecureStringToBSTR( $secure_string )
	$str = $marshal::PtrToStringBSTR( $ptr )
	$marshal::ZeroFreeBSTR( $ptr )
	echo $str.ToString()
}

# Test the credentials of the user against the domain
# Code adapted from: http://serverfault.com/questions/276098/check-if-user-password-input-is-valid-in-powershell-script
function TestCredentials ($credential)
{
	$username = $credential.username
	$password = $credential.GetNetworkCredential().password

	# Get current domain using logged-on user's credentials
	$current_domain = "LDAP://" + ([ADSI]"").distinguishedName
	$domain = New-Object System.DirectoryServices.DirectoryEntry($current_domain,$username,$password)
	
	if ($domain.name -eq $null)
	{
		return $false
	}
	else
	{
		return $true
	}
}