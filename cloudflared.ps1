# Download Cloudflare Tunnel
$downloadUrl = "https://github.com/cloudflare/cloudflared/releases/download/2024.11.1/cloudflared-windows-amd64.exe"
$downloadPath = "$env:TEMP\cloudflared.exe"

# Ensure temporary directory exists
if (-not (Test-Path -Path $env:TEMP)) {
  New-Item -ItemType Directory -Path $env:TEMP
}

# Download Cloudflare Tunnel
Invoke-WebRequest -Uri $downloadUrl -OutFile $downloadPath

# Install Cloudflare Tunnel - Avoid hardcoding the token
$token = "eyJhIjoiMzk0M2Q0ZWMxOGM1MzkxZmJiZTkxNThhNWQ2MjliNTUiLCJ0IjoiZDZmYTU2YjMtODRhNy00MDc0LTljZjgtMmFlODQ5ODM1NzQ2IiwicyI6Ik9UUmxOMkppWWpVdE0yVTROUzAwT1dZekxXSmlOV010WkdJMU56bGpaVFJoTXpnMCJ9"
if (-not $token) {
  Write-Error "Error: CLOUDFLARE_TUNNEL_TOKEN environment variable not set."
  exit 1
}

& $downloadPath service install $token

# Create an RDP Tunnel (Replace with your desired configuration)
& $downloadPath tunnel --url 0.0.0.0:3389
