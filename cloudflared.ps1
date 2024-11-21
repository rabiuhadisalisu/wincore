# Define variables
$cloudflaredExeUrl = "https://github.com/cloudflare/cloudflared/releases/download/2024.10.0/cloudflared-windows-amd64.exe"
$cloudflaredDir = "$env:ProgramFiles\cloudflared"
$cloudflaredExe = "$cloudflaredDir\cloudflared.exe"
$cloudflareAccessToken = "eyJhIjoiMzk0M2Q0ZWMxOGM1MzkxZmJiZTkxNThhNWQ2MjliNTUiLCJ0IjoiZTkxYTJmOWEtODM0Ni00OTVmLWJmZDQtZTE2MGRlYmEzMGY2IiwicyI6Ik9UTTVaVGhpTm1FdE4yVmhNaTAwT1dSaExUazNNekF0WTJVd1lqVmpNekF4WldRMyJ9"
$subdomain = "rdp.rabyte.com.ng"

# Create cloudflared directory if it doesn't exist
if (-not (Test-Path -Path $cloudflaredDir)) {
    New-Item -Path $cloudflaredDir -ItemType Directory | Out-Null
}

# Download cloudflared executable
if (-not (Test-Path -Path $cloudflaredExe)) {
    Write-Host "Downloading Cloudflared executable..."
    Invoke-WebRequest -Uri $cloudflaredExeUrl -OutFile $cloudflaredExe
    icacls $cloudflaredExe /grant Everyone:F
}

# Install the Cloudflare Tunnel service using the provided token
Write-Host "Installing Cloudflare Tunnel service..."
& $cloudflaredExe service install $cloudflareAccessToken

# Verify RDP availability
Write-Host "Checking RDP service on localhost:3389..."
try {
    $tcpConnection = Test-NetConnection -ComputerName localhost -Port 3389
    if (-not $tcpConnection.TcpTestSucceeded) {
        Write-Error "RDP is not reachable on port 3389. Exiting..."
        exit 1
    }
} catch {
    Write-Error "An error occurred while testing RDP connection."
    exit 1
}

# Create a subdomain and expose RDP with Cloudflare Tunnel
Write-Host "Starting Cloudflare Tunnel in the background to expose RDP on $subdomain..."
Start-Process -FilePath $cloudflaredExe -ArgumentList "tunnel --hostname $subdomain --url localhost:3389" -NoNewWindow

# Wait briefly to ensure the process has started
Start-Sleep -Seconds 5

Write-Host "Cloudflare Tunnel has been established for RDP on $subdomain."
Write-Host "Your Password is : P@ssw0rd2024"

# Continue to next commands
Write-Host "Executing further commands..."
# Add any additional commands below this line
