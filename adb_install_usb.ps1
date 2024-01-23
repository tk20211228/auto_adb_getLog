Get-ExecutionPolicy
# Get the first device from the list of attached devices
$deviceId = "123"

# Get device model
$model = "test"
$model = $model.Replace(" ", "_")

Write-Host "Device: $deviceId, Model: $model"

# Prepare log directory
$logdir = ".\log\$model\" + (Get-Date -Format "yyyyMMdd_HHmmss")
Write-Host "Log directory: $logdir"
if (!(Test-Path -Path $logdir)) {
    New-Item -ItemType Directory -Path $logdir
}
adb version

Write-Host "Complete"
pause
exit