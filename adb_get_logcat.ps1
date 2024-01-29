# 現在のタイムスタンプを取得する関数
function GetCurrentTimestamp {
    return (Get-Date -Format "yyyyMMdd_HHmmss")
}

# デバイスのプロパティを取得する関数
function Get-DeviceProperty {
    param (
        [string]$property
    )

    # adb shell getprop コマンドを使用してプロパティを取得し、スペースをアンダースコアに置換
    return (adb shell getprop $property).Replace(" ", "_")
}

# 新しいログディレクトリを作成する関数
function New-LogDirectory {
    param (
        [string]$model
    )

    # ログパスを作成
    $logdir = New-LogPath $model

    # ログディレクトリが存在しない場合は作成
    if (!(Test-Path -Path $logdir)) {
        $dir = New-Item -ItemType Directory -Path $logdir
        $logdir = $dir.FullName
    }

    Write-Host "New-LogDirectory: $logdir"

    return $logdir
}

# 新しいログパスを作成する関数
function New-LogPath {
    param (
        [string]$model
    )

    # スクリプトのルートディレクトリに新しいログパスを作成
    return Join-Path -Path $PSScriptRoot -ChildPath ("log\" + $model + "\$(GetCurrentTimestamp)")
}


function Get-DeviceList {
    param (
        [hashtable]$properties
    )

    $deviceInfo = @{}
    foreach ($property in $properties.Keys) {
        $deviceInfo[$property] = Get-DeviceProperty $properties[$property]
        Write-Host "${property}: $($deviceInfo[$property])"
    }

    return $deviceInfo
}

# Logcatを開始する関数
function Start-Logcat {
    param (
        [string]$deviceId,
        [string]$logdir,
        [string]$model
    )
    # ログファイル名を作成
    $logFileName = "${model}_$(GetCurrentTimestamp)_log.txt"
    # ログファイルのフルパスを作成
    $logFilePath = Join-Path -Path $logdir -ChildPath $logFileName
    # adbの引数を設定
    $adbArguments = "-s $deviceId shell logcat -v threadtime"

    # 新しいウィンドウを開かずにadbプロセスを開始し、出力をログファイルにリダイレクト
    Start-Process -NoNewWindow -FilePath "adb" -ArgumentList $adbArguments -RedirectStandardOutput $logFilePath
}

# 端末が認識されているか確認する関数
function Test-DeviceConnected {
    # "adb devices" コマンドを実行し、出力を取得
    $output = adb devices
    # 出力が "List of devices attached" のみの場合、エラーメッセージを表示してスクリプトを終了
    if ($output.Split("`n").Count -le 2) {
        Write-Host "Device is not recognized. Please set your terminal to debug mode."
        pause
        exit
    }
    # 出力を行ごとに分割し、それぞれの行をチェック
    $output.Split("`n") | ForEach-Object {
        if ($_ -match "unauthorized") {
            Write-Host "Device is not recognized or unauthorized. Please set your terminal to debug mode and authorize this computer for USB debugging."
            pause
            exit
        }
    }
    # Write-Host $output
    # Write-Host "OK"
}

# スクリプトの実行初期段階で、端末が認識されているか確認
Test-DeviceConnected

# スクリプトのルートディレクトリに移動
Set-Location -Path $PSScriptRoot

# スクリプトが管理者権限で実行されていない場合は、新たに管理者権限で実行
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators")) 
{
  Start-Process powershell.exe "-ExecutionPolicy RemoteSigned -File `"$PSCommandPath`"" -Verb RunAs
  exit
}


$properties = @{
    deviceId = "ro.serialno"
    model = "ro.product.model"
    sdkVersion = "ro.build.version.sdk"
    OS = "ro.build.version.release"
    buildName = "ro.build.display.id"
    buildDate = "ro.build.date"
    manufacturer = "ro.product.manufacturer"
    brand = "ro.product.brand"
    productName = "ro.product.name"
    hardware = "ro.hardware"
    bootloader = "ro.bootloader"
    checkjni = "ro.kernel.android.checkjni"
    secure = "ro.secure"
}

$deviceList = Get-DeviceList $properties

# ログディレクトリを作成
$logdir = New-LogDirectory $deviceList.model
# Write-Host "Log directory: $logdir"

# 端末情報を取得
# Get-DeviceInfo $deviceId $logdir $model
# Logcatを開始
Start-Logcat $deviceList.deviceId $logdir $deviceList.model


Write-Host "Press any key to stop logcat..."
pause > null 

# adbサーバーを停止
adb kill-server

Write-Host "Complete"
pause
# ログディレクトリを開く
Invoke-Item $logdir
exit