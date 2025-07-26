# Requires Admin Rights

# Download VSCode System Installer
$installerPath = "$env:TEMP\VSCodeSetup.exe"
Invoke-WebRequest -Uri "https://update.code.visualstudio.com/latest/win32-x64-user/stable" -OutFile $installerPath

# Install VSCode for All Users (System Installer)
Start-Process -FilePath $installerPath -ArgumentList "/silent /mergetasks=!runcode" -Wait

# Path to VSCode executable
$vsCodePath = "${env:ProgramFiles(x86)}\Microsoft VS Code\Code.exe"
if (-Not (Test-Path $vsCodePath)) {
    $vsCodePath = "${env:ProgramFiles}\Microsoft VS Code\Code.exe"
}



# Cleanup
Remove-Item $installerPath -Force
