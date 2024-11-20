# Prompt for credentials once and store them in $c
$c = Get-Credential -Message "Enter your domain administrator credentials"
Write-Host "Credentials stored successfully." -ForegroundColor Green
$c | Export-CliXml -Path "$env:USERPROFILE\domainAdminCreds.xml"
Write-Host "Credentials saved to $env:USERPROFILE\domainAdminCreds.xml" -ForegroundColor Green

# Define server name range (e.g., SERVER1, SERVER2)
$minimumServerCount = 1
$maximumServerCount = 2

# Generate an array of server names (SERVER1, SERVER2, etc.)
$servers = $minimumServerCount..$maximumServerCount | ForEach-Object { "SERVER$_" }
Write-Host "Server names generated successfully." -ForegroundColor Green
Write-Host "Server names: $servers" -ForegroundColor Green
$servers | Out-File -FilePath "$env:USERPROFILE\servers.txt"
Write-Host "Server names saved to $env:USERPROFILE\servers.txt" -ForegroundColor Green

# Rename machines using the stored credentials
$servers | ForEach-Object {
    $vmName = $_
    
    # Rename the computer inside the VM and restart
    Invoke-Command -VMName $vmName -Credential $c -ScriptBlock {
        param ($newName)
        
        # Rename the computer
        Rename-Computer -NewName $newName -Restart
        
    } -ArgumentList $vmName
}
