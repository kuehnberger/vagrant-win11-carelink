# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 2.4.9"

# shows the current project-directory
puts "Vagrant project root is: #{File.expand_path(File.dirname(__FILE__))}"

# 1. Check if the environment variable VAGRANT_KEYBOARD_LANG is set
#    This allows for starting vagrant up with a preset  
#    keyboard layout setting eg. like:
#    "VAGRANT_KEYBOARD_LANG=2 vagrant up" in case you use a German keyboard.
keyboard_choice = ENV['VAGRANT_KEYBOARD_LANG']

# 2. If keyboard_choice is nil (not set), ask the user manually
if keyboard_choice.nil?
  STDOUT.puts "##############################################"
  STDOUT.puts "#####     Keyboard Layout Selection      #####"
  STDOUT.puts "##############################################"
  STDOUT.puts "No Keyboard Layout detected in ENV_VARS"
  STDOUT.print "Please select your Keyboard Layout (1: EN, 2: DE, default is 1:EN): "
  keyboard_choice = STDIN.gets.strip
end

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

  # Native Vagrant method to resize the primary disk - 'primary: true' targets the main OS drive
  config.vm.disk :disk, size: "40GB", primary: true # Win-11 recommends at least +128GB

  # vm custom config
  config.vm.provider "virtualbox" do |vb|
    vb.gui = true
    vb.memory = "8192" # Minimum 4GB recommended, best selection: 6GB (6144)
    vb.cpus = 2 # Minimum requirement for Win11: 2

    # Required for better performance/stability on Win11 guests
    vb.customize ["modifyvm", :id, "--paravirt-provider", "default"]
    vb.customize ["modifyvm", :id, "--nested-hw-virt", "off"]

    # Set the graphics controller
    vb.customize ["modifyvm", :id, "--graphicscontroller", "vmsvga"]
    # Disable 3D to prevent driver hangs during boot
    vb.customize ["modifyvm", :id, "--accelerate3d", "off"]
    # # Optional: Increase video memory for better performance
    vb.customize ["modifyvm", :id, "--vram", "256"]
    # Disable 3D acceleration
    
    # Add this to see the BIOS/EFI process (for boot debugging only)
    vb.customize ["modifyvm", :id, "--bios-logo-fade-in", "on"]
    vb.customize ["modifyvm", :id, "--bios-logo-fade-out", "on"]

    # Enable bidirectional shared clipboard
    vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]   
    # Optional: Enable bidirectional Drag and Drop
    vb.customize ["modifyvm", :id, "--draganddrop", "bidirectional"]

    # Enable the USB Controller
    vb.customize ["modifyvm", :id, "--usb", "on"]
    
    # Choose version: "on" (1.1), "2.0" (ehci), or "3.0" (xhci)
    # Note: 3.0 requires the VirtualBox Extension Pack
    vb.customize ["modifyvm", :id, "--usbxhci", "on"]

    # Option A: Disconnected (Port exists but is not piped)
    vb.customize ["modifyvm", :id, "--uart1", "0x3f8", "4", "--uartmode1", "disconnected"]    

    # (Optional) Create a USB Filter so a specific device connects automatically
    # Use 'VBoxManage list usbhost' on your host to find product/vendor IDs
    # vb.customize ["usbfilter", "add", "0", "--target", :id, "--name", "MyDevice", "--vendorid", "0x1234", "--productid", "0xabcd"]

    # Add a USB Filter for the Silicon Labs Controller; this is the CareLink USB-stick
    vb.customize ["usbfilter", "add", "0",
      "--target", :id,
      "--name", "Silicon Labs CP2102N USB to UART Bridge",
      "--vendorid", "0x10c4",
      "--productid", "0xea60"
    ]
  end


  # Set keyboard and culture - based on Keyboard Language Selection
  # NB you can get the name from the list:
  # [Globalization.CultureInfo]::GetCultures('InstalledWin32Cultures') | Out-GridViewas
  if keyboard_choice == "2"
    # German block
    config.vm.provision "shell", inline: "echo '##############################################\nHallo, User mit Deutscher Tastatur!'"
    config.vm.provision "shell", path: "provision/ps.ps1", args: "set-keyboard-culture-de.ps1"
  else
    # Default English block
    config.vm.provision "shell", inline: "echo '##############################################\nHello User with English keyboard!'"
    config.vm.provision "shell", path: "provision/ps.ps1", args: "set-keyboard-culture-en.ps1"
  end

  # Set TZ
  # tzutil /l lists all available timezone ids
  config.vm.provision "shell", path: "provision/ps.ps1", args: "set-timezone.ps1"

  # Show all files w extensions and show window while dragging
  config.vm.provision "shell", path: "provision/showfiles.ps1", args: "provision/showfiles.ps1"

  # Set Performance: High
  config.vm.provision "shell", inline: "powercfg /SETACTIVE 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c", name: "Set Performance: High"

  # Get and install the CareLink software
  config.vm.provision "shell", path: "provision/ps.ps1", args: "carelink-download-install.ps1"

  #  Win11 debloater
  config.vm.provision "shell", path: "provision/ps.ps1", args: "debloater.ps1"

  # Windows Update - THIS MIGHT TAKE up to 45 minutes
  # config.vm.provision "shell", path: "provision/ps.ps1", args: "win11-update.ps1"

  # Show a summary - mainly for headless setups
  # config.vm.provision "shell", path: "provision/ps.ps1", args: "summary.ps1"

  # configure vagrant/vagrant as autologin user
  config.vm.provision "shell", path: "provision/ps.ps1", args: "autologon-vagrant-config.ps1"
  # set URL as startup 
  config.vm.provision "shell", path: "provision/ps.ps1", args: "open-url.ps1"

  # FINISH
  config.vm.provision "shell", inline: <<-SHELL
    Write-Host "`n`n`n"
    Write-Host "### - ALL FINISHED - Please plug-in your CareLink-USB-Stick now. We will reboot in a few seconds. After Reboot the user: vagrant/vagrant will be logged in automatically. After the reboot of the Windows-VM you can open the website of CareLink Personal to login. - Enjoy your day and leave a star or comment on github - Thanks. - ###"
  SHELL

  # Reboot after provisioning
  config.vm.provision "shell", inline: "shutdown /r /t 5 /f /d p:4:1"
  

end
