Write-Host "### Windows 11 Update starting - might take up to 30 minutes - grab a beverage, relax and let the automation do it's thing ;-)"

$TaskName = "VagrantUpdate"
$Script = {
    Install-PackageProvider -Name NuGet -Force
    Install-Module PSWindowsUpdate -Force
    Get-WindowsUpdate -AcceptAll -Install -AutoReboot
}

# 1. Register and Start the task immediately
$Action = New-ScheduledTaskAction -Execute 'PowerShell.exe' -Argument "-Command & {$Script}"
Register-ScheduledTask -TaskName $TaskName -Action $Action -User "SYSTEM" -Force
Start-ScheduledTask -TaskName $TaskName

# 2. Wait for the task to finish before exiting this provisioner
Write-Host "Waiting for Windows Updates to complete..."
while ((Get-ScheduledTask -TaskName $TaskName).State -eq "Running") {
    Start-Sleep -Seconds 30
    Write-Host "Updates still in progress..."
}

# 3. Clean up
Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false

