<#
.SYNOPSIS
unisntall one or all given choco apps 

.DESCRIPTION
Long description

.EXAMPLE
An example

.NOTES
General notes
#>

param (
    [String]$App,
    [Switch]$UninstallAll 
)

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

$Apps = choco list --local-only

$message = "The following apps were installed `n"
$message | Out-File $logFile -Append
$Apps | Out-File $logFile -Append

if ($UninstallAll){
    $confirmation = Read-Host "You have selected to uninstall all $($Apps.Count) Apps. `nAre you Sure You Want To Proceed?"
    if ($confirmation -eq 'y') {
        "Uninstalling all apps" | Out-File $logFile -Append
        try {
            $uninstallOutput = choco uninstall all -y 
            $uninstallOutput | Out-File $logFile -Append
        }
        catch {
            $errorMsg = $_
            $errorMsg | Out-File $logFile -Append
        }    
    }
} else {
    if(($App -eq $null) -or ($App -eq "")){
        $App = (Read-Host "What app do you want to uninstall?")
    }    
}

if ($Apps -match $App){
    try {
        $uninstallOutput = choco uninstall $App -y --force
        $uninstallOutput | Out-File $logFile -Append
    }
    catch {
        $errorMsg = $_
        $errorMsg | Out-File $logFile -Append
    }
}