# Define variables
$ngrokAuthToken = "2gWiBoxOev9a3bKkUHxZNCOFRIV_74uo5yQrpCM2o3k3aZaTc"
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
& $ngrokExe tcp 3389 &

# Wait for ngrok to start
#Start-Sleep -Seconds 10

# Output ngrok URL to GitHub log
Write-Output "Your Password is : P@ssw0rd2024"
