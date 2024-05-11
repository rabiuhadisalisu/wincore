# Define variables
$ngrokAuthToken = "2Hd7yeF4INCKbg2aP9rGMLnDqBX_5K7WhATjW8eUxS6UoHSRa"
$ngrokExeUrl = "https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-windows-amd64.zip"
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

# Run ngrok to expose RDP port as a background job
$ngrokProcess = Start-Process -FilePath $ngrokExe -ArgumentList "tcp 3389" -NoNewWindow -PassThru

# Wait for ngrok to start
Start-Sleep -Seconds 10

# Get ngrok public URL
$ngrokUrl = ($ngrokProcess | Select-String -Pattern "tcp://.*?:" | Select-Object -First 1).Matches.Value

# Output ngrok URL to GitHub log
Write-Output "Ngrok URL: $ngrokUrl"
