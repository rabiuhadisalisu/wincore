# Define variables
$cloudflaredExeUrl = "https://github.com/cloudflare/cloudflared/releases/download/2024.11.1/cloudflared-windows-amd64.exe"
$cloudflaredDir = "$env:ProgramFiles\cloudflared"
$cloudflaredExe = "$cloudflaredDir\cloudflared.exe"
$cloudflareApiKey = "YOUR_CLOUDFLARE_API_KEY"
$cloudflareEmail = "YOUR_CLOUDFLARE_EMAIL"
$cloudflareZoneId = "YOUR_ZONE_ID"  # Replace with your Cloudflare zone ID
$tunnelName = "rdp-tunnel"
$tunnelConfigFile = "$cloudflaredDir\config.yml"

# Create cloudflared directory if it doesn't exist
if (-not (Test-Path -Path $cloudflaredDir)) {
    New-Item -Path $cloudflaredDir -ItemType Directory | Out-Null
}

# Download cloudflared executable
Invoke-WebRequest -Uri $cloudflaredExeUrl -OutFile $cloudflaredExe

# Make sure cloudflared is executable
icacls $cloudflaredExe /grant Everyone:F

# Create a Cloudflare Tunnel
Write-Host "Creating Cloudflare Tunnel..."
$tunnelResponse = Invoke-RestMethod -Uri "https://api.cloudflare.com/client/v4/accounts/$cloudflareZoneId/tunnels" `
    -Method Post `
    -Headers @{
        "Authorization" = "Bearer $cloudflareApiKey"
        "Content-Type" = "application/json"
    } `
    -Body (ConvertTo-Json @{
        name = $tunnelName
    })

$tunnelId = $tunnelResponse.result.id
Write-Host "Tunnel created with ID: $tunnelId"

# Generate a configuration file for the tunnel
@"
url: tcp://localhost:3389
tunnel: $tunnelId
credentials-file: $cloudflaredDir/$tunnelName.json
"@ | Set-Content -Path $tunnelConfigFile

# Start the Cloudflare Tunnel
Write-Host "Starting Cloudflare Tunnel..."
Start-Process -FilePath $cloudflaredExe -ArgumentList "tunnel --config $tunnelConfigFile" -NoNewWindow -Wait

Write-Host "Cloudflare Tunnel has been established. RDP service is now exposed."
Write-Host "Your Password is : P@ssw0rd2024"
