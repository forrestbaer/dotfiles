#

$CurrentUserProfile = $PROFILE.CurrentUserAllHosts

if (!(Test-Path $PROFILE))
{
    # profile does not currently exist
    Write-Host "Powershell profile does not exist. Copying to $CurrentUserProfile"
} else {
    # profile exists, back it up
    Write-Host "Existing profile discovered, backing up as $PSScriptRoot\dotfile_backup\profile_old.ps1"
}