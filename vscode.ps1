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

# Shortcut path for All Users Start Menu
$startMenuShortcut = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Visual Studio Code.lnk"

# Create Shortcut if it doesn't exist
if (-Not (Test-Path $startMenuShortcut)) {
    $shell = New-Object -ComObject WScript.Shell
    $shortcut = $shell.CreateShortcut($startMenuShortcut)
    $shortcut.TargetPath = $vsCodePath
    $shortcut.IconLocation = "$vsCodePath,0"
    $shortcut.Save()
}

# Function to Pin to Taskbar and Start Menu (requires Syspin tool or PowerShell 5.1 workaround)
function Pin-App {
    param (
        [string]$AppPath
    )

    $script = @"
$Shell = New-Object -ComObject Shell.Application
$Folder = $Shell.Namespace('$(Split-Path $AppPath)')
$Item = $Folder.ParseName('$(Split-Path $AppPath -Leaf)')
\$Item.InvokeVerb('Pin to Start')
\$Item.InvokeVerb('Pin to Taskbar')
"@

    powershell -ExecutionPolicy Bypass -NoProfile -Command $script
}

# Pin VSCode
Pin-App -AppPath $vsCodePath

# Cleanup
Remove-Item $installerPath -Force
