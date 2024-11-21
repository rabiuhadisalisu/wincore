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
$token = $env:CLOUDFLARE_TUNNEL_TOKEN  # Access token from environment variable
if (-not $token) {
  Write-Error "Error: CLOUDFLARE_TUNNEL_TOKEN environment variable not set."
  exit 1
}

& $downloadPath service install --token $token

# Create an RDP Tunnel (Replace with your desired configuration)
& $downloadPath tunnel rdp --url rdp://your_rdp_server_ip:3389
