# Ensure JAVA is installed and keytool is available
$keytool = "$env:JAVA_HOME\bin\keytool.exe"

if (-not (Test-Path $keytool)) {
    $keytool = "keytool"
}

# Define variables
$keystorePath = "$env:USERPROFILE\key.jks"
$alias = "rabyte"
$storepass = "Rabiu2004@"
$keypass = "Rabiu2004@"
$dname = "CN=Rabyte Standard, OU=Rabiu Hadi Salisu, O=Rabyte, L=Kano, S=Kano, C=NG"
$validity = 3650

# Run keytool to generate JKS file
& $keytool -genkeypair `
    -alias $alias `
    -keyalg RSA `
    -keysize 2048 `
    -keystore $keystorePath `
    -storepass $storepass `
    -keypass $keypass `
    -validity $validity `
    -dname $dname

# Output result
if (Test-Path $keystorePath) {
    Write-Host "JKS file created at: $keystorePath"
} else {
    Write-Host "Failed to create JKS file."
}
