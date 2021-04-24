Set-ExecutionPolicy Bypass -Scope Process -Force

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

invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
