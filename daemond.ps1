# Define variables
$tunnelToken = "eyJhIjoiMzk0M2Q0ZWMxOGM1MzkxZmJiZTkxNThhNWQ2MjliNTUiLCJ0IjoiNDdjZTU4NzYtMTQ1MS00MjI0LTllOTktZjAwOTJjY2JkYzQ1IiwicyI6Ik5qRTROek5tWlRVdFpUSmpNaTAwWXpSbExUZ3lNMlF0TlRsbE56Vm1aalV4TlRFMiJ9"
$cfDir = "$env:ProgramFiles\cloudflared"
$cfExe = "$cfDir\cloudflared.exe"
$cfUrl = "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-windows-amd64.msi"

# Create directory
if (-not (Test-Path -Path $cfDir)) {
    New-Item -Path $cfDir -ItemType Directory | Out-Null
}

# Download and Install cloudflared via MSI (cleaner for Windows)
$msiPath = "$cfDir\cloudflared.msi"
Invoke-WebRequest -Uri $cfUrl -OutFile $msiPath
Start-Process msiexec.exe -ArgumentList "/i `"$msiPath`" /qn /norestart" -Wait

# The MSI usually installs to 'C:\Program Files (x86)\cloudflared\cloudflared.exe' 
# or adds it to the PATH. Adjusting path for the script:
$installedExe = "C:\Program Files (x86)\cloudflared\cloudflared.exe"

# Run the tunnel using your specific token from the dashboard
# This connects the local machine to the "Named Tunnel" you created online
Start-Process -FilePath $installedExe -ArgumentList "tunnel --no-autoupdate run --token $tunnelToken" -NoNewWindow

Write-Output "Cloudflare Tunnel is starting. Check your Zero Trust Dashboard for 'Active' status."
Write-Output "Your RDP Password is: P@ssw0rd2024"
