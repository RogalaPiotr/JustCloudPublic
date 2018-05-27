# recreate-vm-from-vhd

PowerShell script to recreate VM's from vhd files in other container. It's very simple method to back to some copy of system. It's such as revert virtual machne to last saved vhd files.

## Variables

$vms = @("SimpleWindowsVM")
select name's your VM to recreate
$sourcecontainerimage = "images"
container name where you have copied vhd's 

## Author
Piotr Rogala
http://justcloud.pl
