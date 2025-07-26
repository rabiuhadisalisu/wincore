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

# === CONFIG ===
$javaHomePath = "C:\hostedtoolcache\windows\Java_Temurin-Hotspot_jdk\21.0.7-6.0\x64"

# ===. Set JAVA_HOME System Environment Variable ===
[Environment]::SetEnvironmentVariable("JAVA_HOME", $javaHomePath, "Machine")
Write-Host "JAVA_HOME set to: $([Environment]::GetEnvironmentVariable("JAVA_HOME", "Machine"))"

# Cleanup
Remove-Item $installerPath -Force
