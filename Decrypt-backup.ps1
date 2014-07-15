<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2014 v4.1.54
	 Created on:   	7/14/2014 3:23 PM
	 Created by:   	James A Kulikowski
	 Organization: 	GFG
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>
$$ = 0
[int]$xMenuChoiceA = 0
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

$xMenuChoiceA = $xMenuChoiceA - 1
$Device = $Devices[$xMenuChoiceA]

python .\backup_tool.py $itunespath\$Device Decrypted-$Device

python keychain_tool.py -d "Decrypted-$Device/KeychainDomain/keychain-backup.plist" "Decrypted-$Device/Manifest.plist"