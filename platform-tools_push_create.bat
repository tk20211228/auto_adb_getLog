@echo off

:: Check for admin privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
  echo Please run the script as an administrator.
  pause >nul
  exit
)

:: Get the full path of the current directory
set "dir=%~dp0"

:: Check if the platform-tools directory is already in the system PATH
echo %Path% | findstr /C:"%dir%platform-tools" 1>nul
if errorlevel 1 (
    :: Add the platform-tools directory to the system PATH
    setx /M Path "%Path%;%dir%platform-tools"
    set "Path=%Path%;%dir%platform-tools"
)

adb version
echo Complete
pause >nul
exit