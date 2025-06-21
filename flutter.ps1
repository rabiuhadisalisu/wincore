# Run as Administrator

$flutterZipUrl = "https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_stable.zip"
$destinationFolder = "C:\tools"
$flutterZipPath = "$env:TEMP\flutter.zip"
$flutterInstallPath = "$destinationFolder\flutter"
$flutterBinPath = "$flutterInstallPath\bin"

# Create destination folder
if (!(Test-Path -Path $destinationFolder)) {
    New-Item -Path $destinationFolder -ItemType Directory -Force
}

# Download Flutter ZIP
Write-Output "Downloading Flutter SDK..."
Invoke-WebRequest -Uri $flutterZipUrl -OutFile $flutterZipPath

# Extract ZIP
Write-Output "Extracting Flutter SDK..."
Expand-Archive -Path $flutterZipPath -DestinationPath $destinationFolder -Force

# Remove ZIP
Remove-Item $flutterZipPath -Force

# Add Flutter to System PATH if not already added
$systemPath = [Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)

if ($systemPath -notlike "*$flutterBinPath*") {
    Write-Output "Adding Flutter to System PATH..."
    $newPath = "$systemPath;$flutterBinPath"
    [Environment]::SetEnvironmentVariable("Path", $newPath, [System.EnvironmentVariableTarget]::Machine)
} else {
    Write-Output "Flutter is already in PATH."
}

# Refresh the current session environment (for current PowerShell only)
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)

# Run flutter doctor
Write-Output "`nRunning flutter doctor..."
& "$flutterBinPath\flutter.bat" doctor
