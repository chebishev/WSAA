# Prompt for domain and DNS server values
$domainName = Read-Host "Enter the domain name"
$dnsServer = Read-Host "Enter the DNS server IP address"

# Validate the inputs
if (-not $domainName) {
    Write-Host "Error: Domain name cannot be empty!" -ForegroundColor Red
    exit
}

if (-not $dnsServer) {
    Write-Host "Error: DNS server address cannot be empty!" -ForegroundColor Red
    exit
}

# Display entered values for confirmation
Write-Host "Domain: $domainName" -ForegroundColor Green
Write-Host "DNS Server: $dnsServer" -ForegroundColor Green

# Read server names from a file
$servers = Get-Content -Path "$env:USERPROFILE\servers.txt"
if (-not $servers) {
    Write-Host "Error: No servers found in the servers.txt file." -ForegroundColor Red
    exit
}

# Import domain admin credentials from a file
$c = Import-CliXml -Path "$env:USERPROFILE\domainAdminCreds.xml"
if ($null -eq $c) {
    Write-Host "Error: Could not load domain administrator credentials." -ForegroundColor Red
    exit
}

# Join each server to the domain using the stored credentials
$servers | ForEach-Object {
    $vmName = $_
    Write-Host "Joining $vmName to domain..." -ForegroundColor Cyan
    
    Invoke-Command -VMName $vmName -Credential $c -ScriptBlock {
        param ($domainName, $dnsServer, $adminCredential)

        # Update DNS settings
        Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses $dnsServer
        # or use index instead
        # Set-DnsClientServerAddress -InterfaceIndex ? -ServerAddresses $dnsServer

        # Join the AD domain
        Add-Computer -DomainName $domainName -Credential $adminCredential -Restart -Force
    } -ArgumentList $domainName, $dnsServer, $c
}

Write-Host "Domain join completed for all servers." -ForegroundColor Green
