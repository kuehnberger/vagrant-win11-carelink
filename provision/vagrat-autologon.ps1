# 1. Configure AutoLogon for the vagrant user
$regPath = "HKLM:\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon"
Set-ItemProperty -Path $regPath -Name "AutoAdminLogon" -Value "1"
Set-ItemProperty -Path $regPath -Name "DefaultUserName" -Value "vagrant"
Set-ItemProperty -Path $regPath -Name "DefaultPassword" -Value "vagrant"
Set-ItemProperty -Path $regPath -Name "AutoLogonCount" -Value 5

