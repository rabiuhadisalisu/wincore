# Specify the URL to download Burp Suite
$burpSuiteUrl = "https://portswigger.net/burp/releases/download?product=community&version=latest&type=Windows"

# Specify the location to save the downloaded installer
$installerPath = "$env:TEMP\burp_suite_community.exe"

# Download Burp Suite installer
Invoke-WebRequest -Uri $burpSuiteUrl -OutFile $installerPath

# Install Burp Suite silently
Start-Process -FilePath $installerPath -ArgumentList "/S" -Wait

# Clean up the installer
Remove-Item $installerPath
