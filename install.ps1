Write-Host "---" -ForegroundColor DarkGray

#
# Copy our powershell profile
#
function CopyPowershellConfig {
    $CurrentUserProfile = $PROFILE.CurrentUserAllHosts
    $CurrentLocation = Get-Location
    $DotfileBackup = "$CurrentLocation\dotfile_backup"

    if (!(Test-Path $CurrentUserProfile)) {
        # profile does not currently exist
        Copy-Item .\powershell\profile.ps1 $CurrentUserProfile -Force
        Write-Host "** PS: Updated $CurrentUserProfile"
        . $CurrentUserProfile
    }
    else {
        # profile exists, back it up first, then try again
        Write-Host "** PS: Existing profile discovered"
        Write-Host "** PS: Backing up as .\dotfile_backup\profile_old.ps1"
        try {
            if (!(Test-Path $DotfileBackup)) {
                Write-Host "** There is no current dotfile backup directory" -ForegroundColor Red
                New-Item -Path $DotfileBackup -ItemType Directory | Out-Null
            }
            Copy-Item $CurrentUserProfile $DotfileBackup -Force
            Remove-Item $CurrentUserProfile -Force
        }
        catch {
            Write-Host "** PS: Unable to perform fs maintenance for existing powershell files!" -ForegroundColor Red
        }
        finally {
            CopyPowershellConfig
        }
    }
}

#
# Copy our visual studio code settings to the correct location
#
function CopyVisualStudioCodeConfig {
    $VsCodeRoamingConfigPath = "$env:APPDATA\Code\User\"

    if (Test-Path $VsCodeRoamingConfigPath) {
        Write-Host "** VS: Copying Visual Studio code configurations"
        try {
            Copy-Item -Path ".\vscode\*" -Destination $VsCodeRoamingConfigPath -Force -Recurse
        }
        catch {
            Write-Host "** VS: Unable to copy files!" -ForegroundColor Red
        }
        finally {
            Write-Host "** VS: Files copied to to $VsCodeRoamingConfigPath"
        }
    }
    else {
        Write-Host "VS: Unable to find VS Code config path." -ForegroundColor Red
    }
}

#
# Start installation
#
CopyPowershellConfig
CopyVisualStudioCodeConfig

Write-Host "---" -ForegroundColor DarkGray