Write-Host "`n-- Loaded Forrests profile.ps1`n"

function eject {
    $ThumbDriveLetter = (Get-WmiObject -Class Win32_Volume | Where-Object {$_.drivetype -eq '2'}  ).DriveLetter
    $Eject = New-Object -comObject Shell.Application
    $Eject.NameSpace(17).ParseName($ThumbDriveLetter).InvokeVerb("Eject")
}