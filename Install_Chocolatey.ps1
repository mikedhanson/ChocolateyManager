Set-ExecutionPolicy Bypass -Scope Process -Force

$PackageName = "ChocolateyManager"
$ChocoManagerPath = "C:\Users\$env:USERNAME\Appdata\Local"
$logFile = "$ChocoManagerPath\$PackageName\log.txt"

if(!(Test-Path -Path "$ChocoManagerPath\$PackageName")){
    New-Item -ItemType Directory -Name $PackageName -Path $ChocoManagerPath -Force
}

$VerbosePreference = 'Continue'
if ($env:ChocolateyInstall) {
    $message = @("Chocolatey was found on the system. Nothing to do" ) -join "`n"
    Write-Warning $message
    $message | Out-File -FilePath $logFile -Force -Append 
}else {
    invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}
