Set-ExecutionPolicy Bypass -Scope Process -Force

invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))