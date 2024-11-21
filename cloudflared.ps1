# Download Cloudflare Tunnel
Invoke-WebRequest -Uri "https://bin.cloudflared.com/latest/cloudflared-linux-amd64.zip" -OutFile cloudflared.zip
Expand-Archive -Path cloudflared.zip

# Install Cloudflare Tunnel
./cloudflared service install --token "eyJhIjoiMzk0M2Q0ZWMxOGM1MzkxZmJiZTkxNThhNWQ2MjliNTUiLCJ0IjoiZDZmYTU2YjMtODRhNy00MDc0LTljZjgtMmFlODQ5ODM1NzQ2IiwicyI6Ik9UUmxOMkppWWpVdE0yVTROUzAwT1dZekxXSmlOV010WkdJMU56bGpaVFJoTXpnMCJ9"

# Create an RDP Tunnel (Replace with your desired configuration)
./cloudflared tunnel rdp --url rdp://0.0.0.0:3389
