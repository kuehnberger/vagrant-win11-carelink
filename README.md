# vagrant-win11-carelink
Medtronic (carelink) does not offer a Linux version of the CareLink Uploader (only Win/Mac).

This is a Windows 11 vm for Virtualbox with automated installation of the CareLink software for Linux-users of Medtronic insulin-pumps in order to upload the pump's data to the CareLink platform from their Linux machines.

This vagrant-script solves this problem, by automatically installing a freshly updated Windows 11 box in Virtualbox, downloads and installs the CareLink Uploader software and allows Linux users to plugin the bluetooth-usb-stick provided by CareLink and upload their insulin-pump-data to the platform of CareLink.

To use it install VirtualBox and Vagrant on your Linux, then do:

# git clone vagrant-win11-vm-carelink
# cd vagrant-win11-vm-carelink
# vagrant up

The initial install might take up to 45 minutes, depending on your bandwidth and the number of windows-updates.

You can cut down the initial installation to under 20 minutes by deleting the block: "# Windows Update Provisioner" in the Vagrantfile.

Subsequent startups need less than 2 minutes.

To stop the VM use:
# vagrant halt

To restart the VM use:
# vagrant up

