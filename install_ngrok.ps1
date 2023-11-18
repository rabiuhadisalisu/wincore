# Download and extract ngrok
Invoke-WebRequest -Uri https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-windows-amd64.zip -OutFile ngrok.zip
Expand-Archive -Path ngrok.zip -DestinationPath .

# Authenticate ngrok
.\ngrok.exe authtoken 2Hd7yeF4INCKbg2aP9rGMLnDqBX_5K7WhATjW8eUxS6UoHSRa
