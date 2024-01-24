function GetCurrentTimestamp {
    return (Get-Date -Format "yyyyMMdd_HHmmss")
}

function Get-DeviceProperty {
    param (
        [string]$property
    )

    return (adb shell getprop $property).Replace(" ", "_")
}

function Create-LogDirectory {
    param (
        [string]$model
    )

    $logdir = Create-LogPath $model

    if (!(Test-Path -Path $logdir)) {
        $dir = New-Item -ItemType Directory -Path $logdir
        $logdir = $dir.FullName
    }

    Write-Host "Create-LogDirectory: $logdir"

    return $logdir
}

function Create-LogPath {
    param (
        [string]$model
    )

    return Join-Path -Path $PSScriptRoot -ChildPath ("log\" + $model + "\$(GetCurrentTimestamp)")
}

function Start-Logcat {
    param (
        [string]$deviceId,
        [string]$logdir,
        [string]$model
    )
    $logFileName = "${model}_$(GetCurrentTimestamp)_log.txt"
    $logFilePath = Join-Path -Path $logdir -ChildPath $logFileName
    $adbArguments = "-s $deviceId shell logcat -v threadtime"

    Start-Process -NoNewWindow -FilePath "adb" -ArgumentList $adbArguments -RedirectStandardOutput $logFilePath
}

Set-Location -Path $PSScriptRoot

if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators")) 
{
  Start-Process powershell.exe "-ExecutionPolicy RemoteSigned -File `"$PSCommandPath`"" -Verb RunAs
  exit
}


$deviceId = Get-DeviceProperty "ro.serialno"
$model = Get-DeviceProperty "ro.product.model"

Write-Host "Device: $deviceId, Model: $model"

$logdir = Create-LogDirectory $model
Write-Host "Log directory: $logdir"

Start-Logcat $deviceId $logdir $model

echo "Press any key to stop logcat..."
pause

adb kill-server

Write-Host "Complete"
pause
Invoke-Item $logdir
exit