# vagrant-win11-carelink

## Intro
Medtronic (carelink) does not offer a Linux version of the CareLink Uploader (only Win/Mac).

This is a Windows 11 vm for Virtualbox with automated download and installation of the CareLink software for Linux-users of Medtronic insulin-pumps in order to upload the pump's data to the CareLink platform from their Linux machines.

This vagrant-script solves this problem, by automatically installing a freshly updated Windows 11 box in Virtualbox, downloading and installing the CareLink Uploader software & drivers. This allows Linux users to plugin the bluetooth-usb-stick provided by CareLink and upload their insulin-pump-data to the platform of CareLink.

## Installation
- Upfront install the requirements: VirtualBox and Vagrant on your Linux. 
- Then on the shell (anywhere you want) get the repo via git and run vagrant which starts up Virtualbox and does all the config and installation automatically:

	git clone https://github.com/kuehnberger/vagrant-win11-carelink.git
	cd vagrant-win11-carelink
	vagrant up

The initial install might take up to 15 minutes, depending on your bandwidth, cpu and memory.

You can cut down the initial installation to under 20 minutes by commenting or deleting the reference to the WindowsUpdate.ps1 script in the Vagrantfile.

Subsequent startups need less than 2 minutes.


## Usage after initial installation

To stop the VM use:

	vagrant halt

To restart the VM use:
	
	vagrant up

