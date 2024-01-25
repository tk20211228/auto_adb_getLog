# Check for admin privileges
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators")) 
{
  Start-Process powershell.exe "-ExecutionPolicy RemoteSigned -File `"$PSCommandPath`"" -Verb RunAs
  exit
}

# Get the full path of the current directory
$dir = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition

# Check if the platform-tools directory is already in the system PATH
$pathArray = $env:Path -split ';'
if ($pathArray -notcontains "$dir\platform-tools") {
    # Add the platform-tools directory to the system PATH
    if (Test-Path "$dir\platform-tools") {
        # Add the platform-tools directory to the system PATH
        [Environment]::SetEnvironmentVariable("Path", $env:Path + ";$dir\platform-tools", [System.EnvironmentVariableTarget]::Machine)
    } else {
        Write-Host "Error: The platform-tools directory does not exist in the current directory."
        pause
        exit
    }
} else { 
    Write-Host "The environment variables are already set for ADB commands to work."
    # Check adb version
    adb version
    Write-Host "Complete"
    pause
    exit    
}
Write-Host "Complete"
pause
exit   
