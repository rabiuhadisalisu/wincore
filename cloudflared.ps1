# Define variables
$downloadUrl = "https://github.com/cloudflare/cloudflared/releases/download/2024.11.1/cloudflared-windows-amd64.exe"
$downloadPath = "$env:TEMP\cloudflared.exe"
$tunnelToken = "eyJhIjoiMzk0M2Q0ZWMxOGM1MzkxZmJiZTkxNThhNWQ2MjliNTUiLCJ0IjoiZDZmYTU2YjMtODRhNy00MDc0LTljZjgtMmFlODQ5ODM1NzQ2IiwicyI6Ik9UUmxOMkppWWpVdE0yVTROUzAwT1dZekxXSmlOV010WkdJMU56bGpaVFJoTXpnMCJ9"
$tunnelName = "RDP_WIN_XXS"
$tunnelUUID = "d6fa56b3-84a7-4074-9cf8-2ae849835746"
$rdpPort = 3389

# Ensure temporary directory exists
if (-not (Test-Path -Path $env:TEMP)) {
  New-Item -ItemType Directory -Path $env:TEMP
}

# Download Cloudflare Tunnel
Write-Host "Downloading Cloudflare Tunnel..."
Invoke-WebRequest -Uri $downloadUrl -OutFile $downloadPath

# Install Cloudflare Tunnel with token
if (-not $tunnelToken) {
  Write-Error "Error: Tunnel token not provided."
  exit 1
}

Write-Host "Installing Cloudflare Tunnel..."
& $downloadPath service install $tunnelToken

# Start the tunnel
Write-Host "Starting Cloudflare Tunnel..."
$tunnelStartCmd = "$downloadPath tunnel --url tcp://localhost:$rdpPort --name $tunnelName"
Invoke-Expression $tunnelStartCmd

# Create the config.yml for the tunnel
$configFilePath = "$env:USERPROFILE\.cloudflared\config.yml"
Write-Host "Creating config.yml file at: $configFilePath"

# Check if the config file directory exists
$configDirectory = [System.IO.Path]::GetDirectoryName($configFilePath)
if (-not (Test-Path -Path $configDirectory)) {
  New-Item -ItemType Directory -Path $configDirectory
}

# Create the config file content
$configContent = @"
tunnel: $tunnelUUID
credentials-file: $configDirectory\$tunnelUUID.json
"@

# Save the config file
Set-Content -Path $configFilePath -Value $configContent

Write-Host "Start Running Tunnel..."
$tunnelStartCmdx = "$downloadPath tunnel run $tunnelUUID"
Invoke-Expression $tunnelStartCmdx

Write-Host "Cloudflare Tunnel for RDP is set up and running with configuration in $configFilePath"
