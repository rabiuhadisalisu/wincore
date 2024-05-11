# Define variables
$username = "rhsalisu"
$fullname = "Rabiu Hadi Salisu"
$password = "Rabiu2004@"

# Create the user account
New-LocalUser -Name $username -FullName $fullname -Password (ConvertTo-SecureString -String $password -AsPlainText -Force) -PasswordNeverExpires:$true -UserMayNotChangePassword:$false

# Add the user to the local Administrators group
Add-LocalGroupMember -Group "Administrators" -Member $username

# Set the password for the user
Set-LocalUser -Name $username -Password (ConvertTo-SecureString -AsPlainText "Rabiu2004@" -Force) -Verbose

# Enable Remote Desktop access for the user
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Value 0
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
Set-LocalUser -Name $username -PasswordNeverExpires:$true

# Disable new user welcome screen
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudExperienceHost\Welcome" -Name "SystemPaneSuggestionsEnabled" -Value 0
