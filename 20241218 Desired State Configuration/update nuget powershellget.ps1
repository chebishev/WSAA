Write-Host "Check current NuGet and PowerShellGet versions"
Write-Host "Current NuGet version"
Get-Module PackageManagement -ListAvailable | Select-Object -Property Name,Version
Write-Host "Current PowerShellGet version"
Get-Module PowerShellGet -ListAvailable | Select-Object -Property Name,Version
Write-Host "Installing NuGet and PowerShellGet"
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Package -Name PowerShellGet -Force
Write-Host "Check updated NuGet and PowerShellGet versions"
Write-Host "Updated NuGet version"
Get-Module PackageManagement -ListAvailable | Select-Object -Property Name,Version
Write-Host "Updated PowerShellGet version"
Get-Module PowerShellGet -ListAvailable | Select-Object -Property Name,Version
