<#
.SYNOPSIS
Loops through txt file and installs apps 

.DESCRIPTION
Long description

.EXAMPLE
.\Choco_installs.ps1

.NOTES
Author: Michael Hanson
Date: 4/24/21
#>

$Apps = Get-Content -Path "$(Get-Location)\ChocolateyApps"

$PackageName = "ChocolateyManager"
$ChocoManagerPath = "C:\Users\$env:USERNAME\Appdata\Local"
$logFile = "$ChocoManagerPath\$PackageName\log.txt"

if(!(Test-Path -Path "$ChocoManagerPath\$PackageName")){
    New-Item -ItemType Directory -Name $PackageName -Path $ChocoManagerPath -Force
}


$VerbosePreference = 'Continue'
if (-not $env:ChocolateyInstall) {
    $message = @(
        "The ChocolateyInstall environment variable was not found."
        "Chocolatey is not detected as installed. Nothing to do."
    ) -join "`n"

    Write-Warning $message
    $message | Out-File -FilePath $logFile -Force -Append 
    return
}

if (-not (Test-Path $env:ChocolateyInstall)) {
    $message = @(
        "No Chocolatey installation detected at '$env:ChocolateyInstall'."
        "Nothing to do."
    ) -join "`n"

    Write-Warning $message
    $message | Out-File -FilePath $logFile -Force -Append
    return
}


foreach ($App in $Apps){

    Write-Host -ForegroundColor Yellow "Installing $App"
    try {
        $InstallOutput = choco Install $App -y
        $message = "`n Installing $App" + $InstallOutput
        $message | Out-File -FilePath $logFile -Force -Append
    }
    catch {
        $message = "Failed to install $App Error: $_"
        Write-Host -ForegroundColor Red $message
        $message | Out-File -FilePath $logFile -Force -Append
    }
}

