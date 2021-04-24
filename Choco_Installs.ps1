<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.EXAMPLE
An example

.NOTES
General notes
#>

$Apps = Get-Content -Path "$(Get-Location)\ChocolateyApps.txt"
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


foreach ($app in $apps){
    Write-Host -ForegroundColor Yellow "Installing $app"
    try {
        $InstallOutput = choco install $app -y
        $message = "`n Installing $app" - $InstallOutput
        $message | Out-File -FilePath $logFile -Force -Append
    }
    catch {
        $message = "Failed to install $app"
        Write-Host $message
        $message | Out-File -FilePath $logFile -Force -Append
    }
}

