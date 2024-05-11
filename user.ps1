# Define variables
$username = "rhsalisu"
$fullname = "Rabiu Hadi Salisu"
$password = "P@ssw0rd2024"
$securePassword = ConvertTo-SecureString -String $password -AsPlainText -Force

# Create the user account
New-LocalUser -Name $username -FullName $fullname -Password $securePassword -PasswordNeverExpires:$true -UserMayNotChangePassword:$false

# Add the user to the local Administrators group
Add-LocalGroupMember -Group "Administrators" -Member $username

# Enable Remote Desktop access for the user
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Value 0
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
Set-LocalUser -Name $username -PasswordNeverExpires:$true

# Disable new user setup screen
$welcomeKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudExperienceHost\Welcome"
$welcomeKeyValue = "SystemPaneSuggestionsEnabled"
$disableValue = 0

# Create the registry key if it doesn't exist
if (-not (Test-Path $welcomeKeyPath)) {
    New-Item -Path $welcomeKeyPath -Force | Out-Null
}

# Set the value to disable the new user setup screen
Set-ItemProperty -Path $welcomeKeyPath -Name $welcomeKeyValue -Value $disableValue

