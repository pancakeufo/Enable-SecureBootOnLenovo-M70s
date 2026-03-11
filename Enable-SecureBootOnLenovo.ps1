<#
.SYNOPSIS
This script enables Secure Boot on Lenovo machines.

.DESCRIPTION
Does not force a reboot (By default. Remove # on line #28 to enable forced reboot.)
Computer must reboot after this script is run for Secure Boot to be enabled. 

.NOTES
1.0 - Initial release

Enable-SecureBootOnLenovo.ps1
v1.0
1/28/2025
By Nathan O'Bryan, MVPr|MCSM
nathan@mcsmlab.com

.LINK
https://www.mcsmlab.com/about
https://github.com/MCSMLab/...
#>

$Data = gwmi -class Lenovo_BiosSetting -namespace root\wmi | Where-Object {$_.CurrentSetting.split(",",[StringSplitOptions]::RemoveEmptyEntries) -eq "SecureBoot"} | Select-Object CurrentSetting
$Status = $Data.CurrentSetting

If ( $Status -like "SecureBoot,Disable*" ) {
    (gwmi -class Lenovo_SetBiosSetting -namespace root\wmi).SetBiosSetting("SecureBoot,Enabled")
    (gwmi -class Lenovo_SaveBiosSettings -namespace root\wmi).SaveBiosSettings()
    # Restart-Computer -Force
}
Else { 
    Write-Host "Secure Boot is already enabled."
}
