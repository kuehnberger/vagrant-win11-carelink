# Download
#####################################################

Write-Host "### - NEXT - CareLinkUploader: Download START - (172 MB) ###"

# 1. Optimize performance by hiding the progress bar
$ProgressPreference = 'SilentlyContinue'

# 2. Force PowerShell to use TLS 1.2 for the connection
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# 3. Create the directory if it doesn't exist
if (!(Test-Path "C:\\tmp")) {
    New-Item -ItemType Directory -Force -Path "C:\\tmp"
}

# 4. Perform the download
$url = "https://carelink.minimed.eu/tools/uploader/CareLinkUploader-ACC-7350-3.13.0-windows-installer.msi"
$output = "C:\\tmp\\CareLinkUploader-ACC-7350-3.13.0-windows-installer.msi"
Invoke-WebRequest -Uri $url -OutFile $output

Write-Host "### - DONE - CareLinkUploader: Download FINISHED ###"

# Installation
#####################################################

Write-Host "### - NEXT - CareLinkUploader: Installation START - this will take some time. ###"

# /passive = Shows progress bar but requires no user interaction
# /norestart = Prevents the MSI from killing the session prematurely
$msiPath = "C:\\tmp\\CareLinkUploader-ACC-7350-3.13.0-windows-installer.msi"
$process = Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$msiPath`" /passive /norestart" -Wait -PassThru

# Check for success (0) or 'Reboot Required' (3010)
if ($process.ExitCode -ne 0 -and $process.ExitCode -ne 3010) {
    Write-Error "Installation failed with exit code $($process.ExitCode)"
    exit $process.ExitCode
}

Write-Host "### - DONE - CareLinkUploader: Installation FINISHED. ###"





