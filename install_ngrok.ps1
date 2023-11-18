# Download and extract ngrok
Invoke-WebRequest -Uri https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-windows-amd64.zip -OutFile ngrok.zip
Expand-Archive -Path ngrok.zip -DestinationPath .

# Create user runneradmin
$securePassword = ConvertTo-SecureString "Rabiu2004@" -AsPlainText -Force
New-LocalUser -Name "runneradmin" -Password $securePassword -FullName "Rabiu Hadi Salisu" -Description "Professional Ext Server"

# Enable Terminal Services
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 0
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name "UserAuthentication" -Value 1

# Authenticate ngrok
.\ngrok.exe authtoken 2Hd7yeF4INCKbg2aP9rGMLnDqBX_5K7WhATjW8eUxS6UoHSRa
