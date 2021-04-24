# ChocolateyManager
Manage Chocolatey 

## Why? 
I was tired of manually running chocolatey updates.

## How does it work? 

There are a few different scripts I threw together. 
```
Choco_createScheduletedTask.ps1
  * Creates a scheduled task and runs updates once a week on a given day time. 

Choco_uninstall.ps1
  * Allows the user to uninstall one or all choco packages 

Choco_installs.ps1
  * Installs any app that you place in the ChocolateyApps.txt file 

Choco_Update.ps1
  * Does what you think. Updates all choco apps installed

Install_chocolatey.ps1
  * Runs the commands to install chocolatey from source.
```

## How to use

```
1. Install chocolatey - .\InstallChocolatey.ps1
2. Open a new powershell window as admin
3. Update the apps file
4. Run .\ChocoInstallApps.ps1
5. 

```

## Usage

Variables that can be passed to docker img. 
```powershell
$TaskName = "ChocoUpdateApps"       # Scheduled task name 
$PackageName = "ChocolateyManager"  # Ransome folder name 
$ChocoManagerPath = "C:\Users\$env:USERNAME\Appdata\Local" # Path for files and logs 
$logFile = "$ChocoManagerPath\$PackageName\log.txt" # Log file 
$ScriptName = "ChocoUpdateApps.ps1" # script name for sched task
$FullScriptPath = "$(Get-location)\$ScriptName"
```

## Example 

```powershell 
Coming soon
```


## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)
