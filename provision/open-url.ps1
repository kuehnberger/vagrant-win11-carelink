# Set the URL to open on login
 # We place a shortcut in the user's Startup folder
$startupFolder = "C:\\Users\\vagrant\\AppData\\Roaming\\Microsoft\\Windows\\Start Menu\\Programs\\Startup"
$shortcutPath = "$startupFolder\\OpenORF.url"
@'
[InternetShortcut]
URL=https://orf.at
'@ | Out-File -FilePath $shortcutPath -Encoding ascii

Write-Host "URL-Configuration complete. Rebooting..."

