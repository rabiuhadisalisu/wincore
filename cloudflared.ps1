# Define variables
$cloudflaredExeUrl = "https://github.com/cloudflare/cloudflared/releases/download/2024.10.0/cloudflared-windows-amd64.exe"
$cloudflaredDir = "$env:ProgramFiles\cloudflared"
$cloudflaredExe = "$cloudflaredDir\cloudflared.exe"
$cloudflareAccessToken = "eyJhIjoiMzk0M2Q0ZWMxOGM1MzkxZmJiZTkxNThhNWQ2MjliNTUiLCJ0IjoiZTkxYTJmOWEtODM0Ni00OTVmLWJmZDQtZTE2MGRlYmEzMGY2IiwicyI6Ik9UTTVaVGhpTm1FdE4yVmhNaTAwT1dSaExUazNNekF0WTJVd1lqVmpNekF4WldRMyJ9"

# Create cloudflared directory if it doesn't exist
if (-not (Test-Path -Path $cloudflaredDir)) {
    New-Item -Path $cloudflaredDir -ItemType Directory | Out-Null
}

# Download cloudflared executable
Invoke-WebRequest -Uri $cloudflaredExeUrl -OutFile $cloudflaredExe

# Make sure cloudflared is executable
icacls $cloudflaredExe /grant Everyone:F

# Install the Cloudflare Tunnel service using the provided token
& $cloudflaredExe service install $cloudflareAccessToken

# Expose port 3306 for MySQL
Start-Process -FilePath $cloudflaredExe -ArgumentList "tunnel --url tcp://localhost:3306" -NoNewWindow -Wait

Write-Host "Cloudflare Tunnel has been established. MySQL service is now exposed on port 3306."
Write-Host "Your Password is : P@ssw0rd2024"
