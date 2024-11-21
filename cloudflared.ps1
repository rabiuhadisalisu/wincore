# Define Variables
$cloudflaredExeUrl = "https://github.com/cloudflare/cloudflared/releases/download/2024.11.1/cloudflared-windows-amd64.exe"
$cloudflaredDir = "$env:ProgramFiles\cloudflared"
$cloudflaredExe = "$cloudflaredDir\cloudflared.exe"
$cloudflareAccessToken = "eyJhIjoiMzk0M2Q0ZWMxOGM1MzkxZmJiZTkxNThhNWQ2MjliNTUiLCJ0IjoiZTkxYTJmOWEtODM0Ni00OTVmLWJmZDQtZTE2MGRlYmEzMGY2IiwicyI6Ik9UTTVaVGhpTm1FdE4yVmhNaTAwT1dSaExUazNNekF0WTJVd1lqVmpNekF4WldRMyJ9"
$tunnelName = "rdp-tunnel"
$tunnelHostname = "rdp.rabyte.com.ng"
$configFile = "$env:USERPROFILE\.cloudflared\config.yml"

# Ensure cloudflared directory exists
if (-not (Test-Path -Path $cloudflaredDir)) {
    New-Item -Path $cloudflaredDir -ItemType Directory | Out-Null
}

# Download and install cloudflared if not already installed
if (-not (Test-Path -Path $cloudflaredExe)) {
    Write-Host "Downloading cloudflared executable..."
    Invoke-WebRequest -Uri $cloudflaredExeUrl -OutFile $cloudflaredExe
    icacls $cloudflaredExe /grant Everyone:F
}

# Authenticate cloudflared using the API token (bypassing login)
Write-Host "Authenticating cloudflared with the API token..."
$env:TUNNEL_ORIGIN_CERT = "$env:USERPROFILE\.cloudflared\cert.pem"  # This will use a saved cert.pem, or you can remove this if not using certificates

# Create a new Cloudflare Tunnel using the provided access token
Write-Host "Creating a new Cloudflare Tunnel..."
& $cloudflaredExe tunnel create $tunnelName --token $cloudflareAccessToken

# Retrieve Tunnel UUID
$tunnelUUID = (& $cloudflaredExe tunnel list | Select-String $tunnelName).ToString().Split()[0]
if (-not $tunnelUUID) {
    Write-Error "Failed to retrieve Tunnel UUID. Exiting..."
    exit 1
}

# Generate a configuration file for the tunnel
Write-Host "Creating configuration file for the tunnel..."
if (-not (Test-Path -Path $configFile)) {
    New-Item -Path $configFile -ItemType File | Out-Null
}

$configContent = @"
url: http://localhost:3389
tunnel: $tunnelUUID
credentials-file: $env:USERPROFILE\.cloudflared\$tunnelUUID.json
"@
Set-Content -Path $configFile -Value $configContent

# Add DNS routing for the tunnel
Write-Host "Adding DNS routing for the tunnel..."
& $cloudflaredExe tunnel route dns $tunnelUUID $tunnelHostname

# Start the tunnel in the background using dispatch
Write-Host "Starting the tunnel in the background..."
Start-Process -FilePath $cloudflaredExe -ArgumentList "tunnel run $tunnelUUID" -NoNewWindow -RedirectStandardOutput "$env:USERPROFILE\cloudflared-log.txt" -RedirectStandardError "$env:USERPROFILE\cloudflared-error-log.txt"

Write-Host "Cloudflare Tunnel setup complete!"
Write-Host "RDP is now accessible at $tunnelHostname. Use this URL in your RDP client."
Write-Host "Check logs for details at $env:USERPROFILE\cloudflared-log.txt"
