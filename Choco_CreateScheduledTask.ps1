<#

.SYNOPSIS
Creates scheduled task that runs weekly on sunday to update all choco apps that are installed on the system

.DESCRIPTION
Creates scheduled task that runs weekly on sunday to update all choco apps that are installed on the system

.EXAMPLE
An example

.NOTES
Author: Michael Hanson
Created: 4/24/2021
Reason: Tired of updating choco apps manually

#>

$TaskName = "ChocoUpdateApps"
$PackageName = "ChocolateyManager"
$ChocoManagerPath = "C:\Users\$env:USERNAME\Appdata\Local"
$logFile = "$ChocoManagerPath\$PackageName\log.txt"
$ScriptName = "Choco_Update.ps1"
$FullScriptPath = "$(Get-location)\$ScriptName"

if(!(Test-Path -Path "$ChocoManagerPath\$PackageName")){
    New-Item -ItemType Directory -Name $PackageName -Path $ChocoManagerPath -Force
}

if (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue) {
    Write-Host "Task exists"
    $message = "$(Get-date) - Unregistering - $taskName"
    $message | Out-File -FilePath $logFile -Append
    Write-Host -ForegroundColor Yellow "UnRegistering - $taskName"
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
}

try {
    Copy-Item -Path $FullScriptPath -Destination "$ChocoManagerPath\$PackageName" -Force
}
catch {
    Write-Error "Failed to copy update script"
}

$DoesTaskExist = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue

if ( ! $DoesTaskExist ) {
    $ActionArgs = '-ExecutionPolicy Bypass -windowstyle Hidden -File "C:\Users\' + $env:USERNAME + '\Appdata\Local\ChocolateyManager\Choco_Update.ps1"'
    $Action = New-ScheduledTaskAction -Execute 'powershell' -Argument $ActionArgs
    $Trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Sunday -At 8AM
    $Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -ExecutionTimeLimit (New-TimeSpan -Minutes 45) -StartWhenAvailable
    $principal = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Users" -RunLevel Highest
    #$Principal = New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest
    $Task = New-ScheduledTask -Action $Action -Trigger $Trigger -Settings $Settings -Principal $Principal

    try {
        Register-ScheduledTask -TaskName $TaskName -InputObject $Task
        $message = "$(Get-date) - 
        Task properties: 
            * Action: $($Action | Format-List | Out-String)
            * Settings: $($Settings | Format-List | Out-String)
            * Principal: $($principal | Format-List | Out-String)
        Creating task: $($task | Format-List | Out-String)
        "
        $message | Out-File -FilePath $logFile -Append
    }
    catch {
        $message = "$(Get-date) - ERROR: Failed to create scheduled task. Error [$_]"
        $message | Out-File -FilePath $logFile -Append
    }
}

#$DoesTaskExist = Get-ScheduledTask -TaskName $TaskName
if (Get-ScheduledTask -TaskName $TaskName) {
    Write-Host "Succeeded = True"
    $message = "$(Get-date) - Succeeded = True | Task created"
    $message | Out-File -FilePath $logFile -Append
}
else {
    Write-Host "Succeeded = False"
    $message = "$(Get-date) - Succeeded = False"
    $message | Out-File -FilePath $logFile -Append
}
