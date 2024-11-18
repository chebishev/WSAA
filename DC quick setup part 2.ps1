# Ensure the AD module is imported
Import-Module ActiveDirectory

# Create Computer objects for the two servers
Write-Host "Creating computer objects..." -ForegroundColor Yellow
1..2 | ForEach-Object {
    $computerName = "SERVER$_"
    New-ADComputer -Name $computerName `
                   -SamAccountName $computerName `
                   -Enabled $true
    Write-Host "Created computer object: $computerName" -ForegroundColor Green
}

# Create Admin User
New-ADUser -Name "Admin User" `
           -UserPrincipalName "admin.user@wsaa.lab" `
           -AccountPassword (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force) `
           -DisplayName "Admin User" `
           -Enabled $true `
           -GivenName "Admin" `
           -Surname "User" `
           -PassThru

Write-Host "Admin User created successfully." -ForegroundColor Green

# Add Admin User to Domain Admins group using DistinguishedName
Add-ADGroupMember -Identity "Domain Admins" -Members "CN=Admin User,CN=Users,DC=wsaa,DC=lab"

Write-Host "Admin User added to Domain Admins group." -ForegroundColor Green

# Create Regular User
New-ADUser -Name "Regular User" `
           -UserPrincipalName "regular.user@wsaa.lab" `
           -AccountPassword (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force) `
           -DisplayName "Regular User" `
           -Enabled $true `
           -GivenName "Regular" `
           -Surname "User" `
           -PassThru

Write-Host "Regular User created successfully." -ForegroundColor Green