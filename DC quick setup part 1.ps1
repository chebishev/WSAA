# Script 1: Setup AD DS and Reboot
# Install the AD DS role
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
Write-Host "Installed Active Directory Domain Services feature." -ForegroundColor Cyan

# Import the AD DS deployment module
Import-Module ADDSDeployment
Write-Host "Imported ADDSDeployment module." -ForegroundColor Cyan

# Install a new AD forest and domain
Write-Host "Installing new AD Forest and Domain..." -ForegroundColor Yellow
Install-ADDSForest `
    -CreateDnsDelegation:$false `
    -DatabasePath "C:\Windows\NTDS" `
    -DomainMode "WinThreshold" `
    -DomainName "wsaa.lab" `
    -DomainNetbiosName "WSAA" `
    -ForestMode "WinThreshold" `
    -InstallDns:$true `
    -LogPath "C:\Windows\NTDS" `
    -NoRebootOnCompletion:$false `
    -SysvolPath "C:\Windows\SYSVOL" `
    -Force:$true

Write-Host "AD DS Forest installed. The system will now restart." -ForegroundColor Yellow