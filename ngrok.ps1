# Define variables
$ngrokAuthToken = "2Hd7yeF4INCKbg2aP9rGMLnDqBX_5K7WhATjW8eUxS6UoHSRa"
$ngrokExeUrl = "https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-windows-amd64.zip"
$ngrokDir = "$env:ProgramFiles\ngrok"
$ngrokExe = "$ngrokDir\ngrok.exe"

# Create ngrok directory if it doesn't exist
if (-not (Test-Path -Path $ngrokDir)) {
    New-Item -Path $ngrokDir -ItemType Directory | Out-Null
}

# Download ngrok executable
Invoke-WebRequest -Uri $ngrokExeUrl -OutFile "$ngrokDir\ngrok.zip"

# Unzip ngrok executable
Expand-Archive -Path "$ngrokDir\ngrok.zip" -DestinationPath $ngrokDir

# Authenticate ngrok
Start-Process -FilePath $ngrokExe -ArgumentList "authtoken $ngrokAuthToken" -NoNewWindow -Wait

# Run ngrok to expose RDP port
# & $ngrokExe tcp 3389

# Run ngrok to expose RDP port and capture its output
$ngrokOutput = & $ngrokExe tcp 3389

# Wait for ngrok to start
Start-Sleep -Seconds 10

# Parse ngrok output to extract public URL
$ngrokUrl = $ngrokOutput | Select-String -Pattern "tcp://.*?:" -AllMatches | Select-Object -First 1 -Expand Matches | ForEach-Object { $_.Value }

# Output ngrok URL to GitHub log
Write-Output "Ngrok URL: $ngrokUrl"
