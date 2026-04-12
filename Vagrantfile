Vagrant.configure("2") do |config|
  # Basics (box, version, guest)
  config.vm.box = "gusztavvargadr/windows-11"
  config.vm.box_version = "2601.0.0"
  config.vm.guest = :windows
 
  # Set the communicator to winrm istead of default ssh
  config.vm.communicator = "winrm"
  config.winrm.retry_limit = 50
  config.winrm.retry_delay = 10

  # Increase timeout to 30 minutes to handle "Getting Ready" screens
  # Windows 11 "Getting Ready" often takes 6-8 minutes on virtualized hardware. 
  # This prevents Vagrant from declaring the VM "failed" while Windows is still "thinking".
  config.vm.boot_timeout = 1800

  # vm custom config
  config.vm.provider "virtualbox" do |vb|
    vb.gui = true
    vb.memory = "8192" # Minimum 4GB recommended
    vb.cpus = 2

    # Required for better performance/stability on Win11 guests
    vb.customize ["modifyvm", :id, "--paravirt-provider", "default"]
    vb.customize ["modifyvm", :id, "--nested-hw-virt", "off"]

    # The VMSVGA controller is common, but VBoxSVGA of vboxvga is often more stable for Windows guests experiencing black screens.
    vb.customize ["modifyvm", :id, "--graphicscontroller", "vmsvga"]
    # Disable 3D to prevent driver hangs during boot
    vb.customize ["modifyvm", :id, "--accelerate3d", "off"]
    # Set the video RAM
    vb.customize ["modifyvm", :id, "--vram", "256"]

    # Add this to see the BIOS/EFI process:
    vb.customize ["modifyvm", :id, "--bios-logo-fade-in", "off"]
    vb.customize ["modifyvm", :id, "--bios-logo-fade-out", "off"]

  end

# Adjust Language, Timezone and Keyboard Settings
  config.vm.provision "shell", powershell_args: "-ExecutionPolicy Bypass", inline: <<-SHELL
    Write-Host "### - NEXT - Setting Language, Timezone and Keyboard"

    # 1. Set Timezone to Berlin
    Set-TimeZone -Id "W. Europe Standard Time"

    # 2. Set System Locale and UI Language to German (Germany)
    Set-WinSystemLocale -SystemLocale de-DE
    Set-WinUserLanguageList -LanguageList de-DE -Force
    Set-Culture de-DE

    # 3. Set KeyBoard layout to German
    Set-WinDefaultInputMethodOverride -InputTip "0407:00000407"

    # 4. Define the language list properly
    $1 = New-WinUserLanguageList de-DE
    Set-WinUserLanguageList -LanguageList $1 -Force
    Write-Host "### - DONE - Language, Timezone and Keyboard set to German/Berlin."
  SHELL



# Get the CareLink Software
  config.vm.provision "shell", powershell_args: "-ExecutionPolicy Bypass", inline: <<-SHELL
    Write-Host "### - NEXT - CareLinkUploader: Download START - might take a while (172 MB)"
    
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
    
    Write-Host "### - DONE - CareLinkUploader: Download FINISHED"
  SHELL


# Install the CareLink Software - run the silent MSI installation & reboot
  config.vm.provision "shell", inline: <<-SHELL
    Write-Host "### - NEXT - CareLinkUploader: Installation START - this will take some time"

    # /passive = Shows progress bar but requires no user interaction
    # /norestart = Prevents the MSI from killing the session prematurely
    $msiPath = "C:\\tmp\\CareLinkUploader-ACC-7350-3.13.0-windows-installer.msi"
    $process = Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$msiPath`" /passive /norestart" -Wait -PassThru
    
    # Check for success (0) or 'Reboot Required' (3010)
    if ($process.ExitCode -ne 0 -and $process.ExitCode -ne 3010) {
        Write-Error "Installation failed with exit code $($process.ExitCode)"
        exit $process.ExitCode
    }

    Write-Host "### - DONE - CareLinkUploader: Installation FINISHED. I will reboot now."
  SHELL


# Reboot - This tells Vagrant to restart the guest and wait for it to come back online
  config.vm.provision "shell", inline: "shutdown /r /t 5 /f /d p:4:1"


# FINISH
  config.vm.provision "shell", inline: <<-SHELL
    Write-Host "`n`n`n"
    Write-Host "### - ALL FINISHED - Please plug-in your USB-Stick now. Then switch to the Windows-VM, where you can open the website of CareLink Personal to login. - Enjoy your day and leave a comment or start on github - Thanks."
  SHELL

end
