# === Temporarily allow script execution ===
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

# === CONFIG ===
$javaHomePath = "C:\hostedtoolcache\windows\Java_Temurin-Hotspot_jdk\21.0.7-6.0\x64"
$flutterArchiveUrl = "https://docs.flutter.dev/install/archive"
$downloadFolder = "$env:USERPROFILE\Downloads"
$extractFolder = "$env:USERPROFILE\dev"
$flutterFolder = Join-Path $extractFolder "flutter"
$flutterBin = Join-Path $flutterFolder "bin"

# === 1. Set JAVA_HOME System Environment Variable ===
[Environment]::SetEnvironmentVariable("JAVA_HOME", $javaHomePath, "Machine")
Write-Host "JAVA_HOME set to: $([Environment]::GetEnvironmentVariable("JAVA_HOME", "Machine"))"

# === 2. Fetch latest Flutter stable ZIP URL ===
Write-Host "Fetching latest Flutter Windows ZIP URL..."

$html = Invoke-WebRequest -Uri $flutterArchiveUrl -UseBasicParsing
$flutterZipRelativeUrl = ($html.Links | Where-Object {
    $_.href -match "flutter_windows_.*-stable.zip"
} | Select-Object -First 1).href

if (-not $flutterZipRelativeUrl) {
    Write-Error "Could not find a valid Flutter Windows ZIP URL."
    exit 1
}

$flutterZipUrl = "https://storage.googleapis.com" + $flutterZipRelativeUrl
$zipFileName = Split-Path $flutterZipUrl -Leaf
$zipPath = Join-Path $downloadFolder $zipFileName

Write-Host "Downloading: $flutterZipUrl"
Invoke-WebRequest -Uri $flutterZipUrl -OutFile $zipPath

# === 3. Extract Flutter ZIP ===
Write-Host "Extracting $zipFileName to $extractFolder..."
Expand-Archive -Path $zipPath -DestinationPath $extractFolder -Force
Write-Host "Flutter extracted to: $flutterFolder"

# === 4. Add Flutter to PATH if not already set ===
$currentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")

if ($currentPath -notmatch [regex]::Escape($flutterBin)) {
    $newPath = $currentPath + ";" + $flutterBin
    [Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
    Write-Host "Flutter bin added to system PATH: $flutterBin"
} else {
    Write-Host "Flutter bin already exists in system PATH."
}

Write-Host ""
Write-Host "Setup complete. Please restart your terminal or computer to apply changes."
