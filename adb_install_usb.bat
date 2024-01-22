@echo off
setlocal enabledelayedexpansion

:: Check for admin privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
  echo Please run the script as an administrator.
  pause >nul
  exit
)

adb devices

:: Get the first device from the list of attached devices
for /f "tokens=1" %%n in ('adb devices ^| findstr /r /v "List of devices attached"') do (
    set "deviceId=%%n"
    goto :continue
)
:continue

:: Get device model
adb -s %deviceId% shell getprop ro.product.model > model.txt
set /p model=<model.txt
set "model=!model: =_!"
del model.txt

echo Device: !deviceId!, Model: !model!

:: Prepare log directory
set "hour=%time:~0,2%"
if "%hour:~0,1%" == " " set "hour=0%hour:~1,1%"
set "logdir=.\log\!model!\%date:~0,4%%date:~5,2%%date:~8,2%_%hour%%time:~3,2%%time:~6,2%"
echo Log directory: !logdir!
if not exist "!logdir!" mkdir "!logdir!"

@REM :: Write device info to file
@REM echo Model: !model! > !logdir!\deviceinfo.txt
@REM adb -s %deviceId% shell getprop ro.build.version.release > version.txt
@REM set /p version=<version.txt
@REM echo Android Version: !version! >> !logdir!\deviceinfo.txt
@REM del version.txt
@REM adb -s %deviceId% get-serialno > serialno.txt
@REM set /p serial=<serialno.txt
@REM echo Serial Number: !serial! >> !logdir!\deviceinfo.txt
@REM del serialno.txt

@REM :: Start logcat
@REM start /b adb -s %deviceId% shell logcat -v threadtime > !logdir!\log.txt

echo Press any key to stop logcat...
pause >nul

adb kill-server

echo Complete
pause >nul
exit
