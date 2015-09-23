# Author: Scott Willett
# Version: 2015-09-23
#
# Modules involving encrypting credentials and storing them securely.
# Powershell SecureStrings can only be decrypted on the same machine and account they were encrypted on.

# Request credentials from the user, convert them to JSON format, and store them in a .json file
# Will only do this if the credentials are valid, and will keep asking until they're valid or the user cancels.
# Returns the credentials
function RequestCredentials ()
{
	# Flag to indicate if the credentials are valid or not
	$not_valid = $true
	
	# Request credentials until they're valid, then write them to a file
	while ($not_valid)
	{
		# Gets the credentials from the user
		$credential = Get-Credential -Message "Please input your Groves domain username and password. Note: Passwords expire every three months."

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
			$user_config | ConvertTo-JSON | Out-File "user_config.json" -Force
			
			# The credentials are now valid
			$not_valid = $false
			
		}
	}
	
	return $credential
	
}

# Draw in username and password data from a JSON file and return a PS-Credential object
# If the file doesn't exist or the credentials are invalid, request them
function GetCredentials ()
{

	# If the config file exists
	if (Test-Path ".\user_config.json")
	{
		# Draw JSON content in from a settings file
		$settings = Get-Content -Raw ".\user_config.json" | ConvertFrom-JSON

		$temp_credential = New-Object -typename System.Management.Automation.PSCredential -argumentlist "placeholder", ($settings.username | ConvertTo-SecureString)
		
		# Construct the PS-Credential object from the above data
		$credential = New-Object -typename System.Management.Automation.PSCredential -argumentlist $temp_credential.GetNetworkCredential().password, ($settings.password | ConvertTo-SecureString)
	
		# Request credentials if they're invalid (perhaps the password has expired, or the account is disabled)
		if (!(TestCredentials($credential)))
		{
			RequestCredentials
		}
		
		# Return the PS-Credential object
		return $credential
	}
	else	# Request credentials if the config file doesn't exist
	{
		RequestCredentials
	}
}

# Decrypt a powershell securestring
# $secure_string = Powershell secure string in plain text
# Code adapted from: http://blogs.msdn.com/b/besidethepoint/archive/2010/09/21/decrypt-secure-strings-in-powershell.aspx
# Note: This function is not being used as the assembly isn't available on RT :(
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
# Note: Issues using the assemblies. Instead attempting to map a drive with the credentials, then testing the path.
function TestCredentials ($credential)
{
	#$username = $credential.username
	#$password = $credential.GetNetworkCredential().password

	# Get the DNS suffix from DHCP and convert it to the distinguishedName. This is the domain we'll authenticate against.
	#$dhcp_domain = (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\" -Name "DhcpDomain").DhcpDomain
	#$domain_dn = ""
	#foreach($dc in $dhcp_domain.Split("."))
	#{
#		$domain_dn += "DC=$($dc),"
	#}
	#$domain_dn = $domain_dn.substring(0, $domain_dn.length - 1)	# Strip the last comma
	#$assemType = 'System.DirectoryServices.AccountManagement'
    #$assem = [reflection.assembly]::LoadWithPartialName($assemType)
	#$pc = New-Object -TypeName System.DirectoryServices.AccountManagement.PrincipalContext 'Domain', $dhcp_domain
    
	#$pc.ValidateCredentials($username, $password)
	
	# Get current domain using logged-on user's credentials
	#$current_domain = "LDAP://$($domain_dn)"
	#$domain = New-Object System.DirectoryServices.DirectoryEntry($current_domain,$username,$password)
	
	New-PSDrive -Name "X" -PSProvider FileSystem -Root "\\rt-deploy\rt-deploy$" -Credential $credential
	$authenticated = Test-Path "X:\"
	Remove-PSDrive -Name "X"
	return $authenticated
	#if ($domain.name -eq $null)
	#{
	#	return $false
	#}
	#else
	#{
	#	return $true
	#}
}