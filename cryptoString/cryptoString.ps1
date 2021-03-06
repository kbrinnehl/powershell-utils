<#
.SYNOPSIS
    Encrypt and descrypt string.
.DESCRIPTION
    Small script to encrypt a string into a textfile and later decrypt using the PowerShell PSCredential provider.
	Can be used for storing a password credential in an automation script.
.PARAMETER operation
    Specify wheter to encrypt or decrypt.
.PARAMETER path
	Specify the path of the output file. If no path is specified, a file named cred.txt in the script root directory will be used.
.PARAMETER string
	Used when encrypting a string. The string must be encapuslated with quotes.
.EXAMPLE
    .\cryptoString.ps1 -operation:encrypt -path .\cred.txt -string "ImALittleTeaPotShortAndStout"
.EXAMPLE
	.\cryptoString.ps1 -operation:decrypt -path .\cred.txt
.NOTES
    Author: Kevin Brinnehl
    Date:   07/19/2016    
#>

Param(
	[Parameter(Mandatory=$true,Position=1)]
	[ValidateSet('encrypt','decrypt')]	
  		[string]$operation,
	[Parameter(Mandatory=$false,Position=2)]
		[string]$path = "$PSScriptRoot\cred.txt",
	[Parameter(Mandatory=$false,Position=3)]
		[string]$string
)

If($operation -eq "encrypt")
	{
	Try
		{
		$string | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Out-File $path
		}
	Catch
		{
		$Error[0]
		}
	}
	
ElseIf($operation -eq "decrypt")
	{
	Try
		{
		$secureString = Get-Content $path | ConvertTo-SecureString
		$pass = (New-Object System.Management.Automation.PSCredential 'N/A', $secureString).GetNetworkCredential().Password
		}
	Catch
		{
		$Error[0]
		}
	return $pass
	}