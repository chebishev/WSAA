# Copy the needed amount of vhdx templates to your "Virtual Hard Disks" folder
# You can find it here (run in PowerShell as Administrator):
Get-VMHost -ComputerName $env:computername | select -ExpandProperty VirtualHardDiskPath
# make sure that the variable names and the disk names will match
# Open PowerShell as Administrator in the directory of the script
# Run the script
.\CreateVMs.ps1

# Video instruction:
https://youtu.be/qBU_1n2gOhg