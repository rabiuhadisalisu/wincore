# === CONFIG ===
$javaHomePath = "C:\hostedtoolcache\windows\Java_Temurin-Hotspot_jdk\21.0.7-6.0\x64"
$flutterArchiveUrl = "https://docs.flutter.dev/install/archive"
$downloadFolder = "$env:USERPROFILE\Downloads"
$extractFolder = "$env:USERPROFILE\dev"
$flutterFolder = Join-Path $extractFolder "flutter"
$flutterBin = Join-Path $flutterFolder "bin"

# === 1. Set JAVA_HOME System Environment Variable ===
[Environment]::SetEnvironmentVariable("JAVA_HOME", $javaHomePath, "Machine")
Write-Host "✅ JAVA_HOME set to: $([Environment]::GetEnvironmentVariable("JAVA_HOME", "Machine"))"

# === 2. Get the latest Flutter Windows stable version ZIP from the archive page ===
Write-Host "`n📥 Fetching latest Flutter Windows ZIP URL..."

$html = Invoke-WebRequest -Uri $flutterArchiveUrl -UseBasicParsing

$flutterZipRelativeUrl = ($html.Links | Where-Object {
    $_.href -match "flutter_windows_.*-stable.zip"
} | Select-Object -First 1).href

if (-not $flutterZipRelativeUrl) {
    Write-Error "❌ Could not find a valid Flutter Windows ZIP URL."
    exit 1
}

$flutterZipUrl = "https://storage.googleapis.com" + $flutterZipRelativeUrl
$zipFileName = Split-Path $flutterZipUrl -Leaf
$zipPath = Join-Path $downloadFolder $zipFileName

Write-Host "📦 Downloading: $flutterZipUrl"
Invoke-WebRequest -Uri $flutterZipUrl -OutFile $zipPath

# === 3. Extract Flutter ZIP ===
Write-Host "📂 Extracting to $extractFolder..."
Expand-Archive -Path $zipPath -DestinationPath $extractFolder -Force
Write-Host "✅ Flutter extracted to: $flutterFolder"

# === 4. Set Flutter BIN to System PATH if not present ===
$envPath = [Environment]::GetEnvironmentVariable("Path", "Machine")

if ($envPath -notmatch [regex]::Escape($flutterBin)) {
    $newPath = $envPath + ";" + $flutterBin
    [Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
    Write-Host "✅ Flutter bin path added to system PATH: $flutterBin"
} else {
    Write-Host "ℹ️ Flutter bin path already exists in system PATH."
}

Write-Host "`n🎉 Setup Complete! You may need to restart your terminal or computer to apply changes."
