<#	
	.Notes
		===========================================================================
		 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2014 v4.1.54
		 Created on:   	7/14/2014 3:23 PM
	 	Created by:   	KSI SYN
	 	Organization: 	SCN
	 	Filename:     	Decrypt-backup.ps1
		===========================================================================
	
	.SYNOPSIS
		Decrypt iOS backup and display Keybag contents	

	.DESCRIPTION
		Function/Script to Automate the process of decrypting an iOS encrypted backup then parseing the backup plist keybag

	.PARAMETER Sanitize
		The sanitize parameter is a [system.Boolean] value that is defaulted to True. This masks passwords in the display output. Setting -Sanitize $false in the command line param's when invokeing this script will unhide all password data and display in clear text.

	.EXAMPLE 
		Decrypt-backup.ps1

	.EXAMPLE
		Decrypt-backup.ps1 -Sanitize $false

	.OUTPUTS
		[system.string]
#>

param (
[System.Boolean]$Sanitize = $true
)

[int]$i = 0;[int]$xMenuChoiceA = 0
$itunespath = "$env:APPDATA\Apple Computer\MobileSync\Backup"
$Devices = Get-ChildItem $itunespath | where { $_.Attributes -eq 'Directory' }

clear
Write-Host “`n`tDecrypt iOS Backup`n” -ForegroundColor Magenta
Write-Host “`t`tPlease select the Device UDID to decrypt `n” -Fore Cyan

foreach ($Device in $Devices.name)
{
	$i++
	Write-Host “`t`t`t$i. $Device” -Fore Cyan
}

while ($xMenuChoiceA -lt 1 -or $xMenuChoiceA -gt $i)
{
	[Int]$xMenuChoiceA = read-host "Please enter an option 1 to $i..."	
	if ($xMenuChoiceA -lt 0 -or $xMenuChoiceA -gt $i)
	{	
		Write-Host “`tPlease select one of the options available.`n” -Fore Red; start-Sleep -Seconds 1
	}
}

clear
$xMenuChoiceA = $xMenuChoiceA - 1; $Device = $Devices[$xMenuChoiceA]
python .\backup_tool.py $itunespath\$Device Decrypted-$Device
sleep -Seconds 1; clear

if ($Sanitize -eq $true)
{
	python .\keychain_tool.py -ds "Decrypted-$Device/KeychainDomain/keychain-backup.plist" "Decrypted-$Device/Manifest.plist"
 }
else
{
	python .\keychain_tool.py -d "Decrypted-$Device/KeychainDomain/keychain-backup.plist" "Decrypted-$Device/Manifest.plist"
}