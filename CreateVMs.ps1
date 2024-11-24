# Prompt for VM generation (validate input for 1 or 2)
do {
    $generation = Read-Host "Enter the VM generation (1 or 2)"
    if ($generation -notmatch "^[12]$") {
        Write-Host "Invalid input. Please enter 1 or 2." -ForegroundColor Red
    }
} while ($generation -notmatch "^[12]$")

# Dynamically obtain the VHDX path
$vhdxPath = Get-VMHost -ComputerName $env:COMPUTERNAME | Select-Object -ExpandProperty VirtualHardDiskPath
if (-not $vhdxPath) {
    Write-Host "Failed to retrieve VHDX path. Exiting script." -ForegroundColor Red
    return
}

Write-Host "Using VHDX path: $vhdxPath" -ForegroundColor Green

# Prompt for RAM size
do {
    $ramSize = Read-Host "Enter the RAM size for each VM (e.g., 2GB, 4GB, 8GB)"
    if ($ramSize -notmatch "^\d+(MB|GB)$") {
        Write-Host "Invalid input. Please specify a numeric value followed by MB or GB (e.g., 2GB)." -ForegroundColor Red
    }
} while ($ramSize -notmatch "^\d+(MB|GB)$")

# Prompt to decide whether to add a switch
$switchOption = Read-Host "Do you want to add a virtual switch? (Yes/No)"
if ($switchOption -match "^(Yes|Y)$") {
    do {
        $switchName = Read-Host "Enter the virtual switch name"
        if (-not (Get-VMSwitch | Where-Object {$_.Name -eq $switchName})) {
            Write-Host "Invalid switch name. Please ensure the switch exists." -ForegroundColor Red
        }
    } while (-not (Get-VMSwitch | Where-Object {$_.Name -eq $switchName}))
    Write-Host "Using virtual switch: $switchName" -ForegroundColor Green
} else {
    $switchName = $null
    Write-Host "No virtual switch will be added." -ForegroundColor Yellow
}

# Prompt for VM name range
$minimumVMCount = 1
$maximumVMCount = Read-Host "How many VM's do you want to create? (Minimum: $minimumVMCount)"

if (-not ($minimumVMCount -as [int]) -or -not ($maximumVMCount -as [int])) {
    Write-Host "Invalid VM number range. Please enter numeric values." -ForegroundColor Red
    return
}

# Generate an array of server names (e.g., SERVER1, SERVER2, etc.)
$vms = $minimumVMCount..$maximumVMCount | ForEach-Object { "SERVER$_" }
Write-Host "VM names generated successfully: $vms" -ForegroundColor Green

# Uncomment to save VM names to a file
# $vms | Out-File -FilePath "$env:USERPROFILE\vms.txt"
# Write-Host "VM names saved to $env:USERPROFILE\vms.txt" -ForegroundColor Green

# Create VMs
$vms | ForEach-Object {
    $vmName = $_
    $vhdxFilePath = Join-Path -Path $vhdxPath -ChildPath "${vmName}.vhdx"

    Write-Host "Creating VM: $vmName" -ForegroundColor Cyan

    $newVMParams = @{
        Name                = $vmName
        Generation          = $generation
        MemoryStartupBytes  = $ramSize
        VHDPath             = $vhdxFilePath
    }

    if ($switchName) {
        $newVMParams.SwitchName = $switchName
    }

    New-VM @newVMParams
}

Write-Host "VM creation process completed." -ForegroundColor Green
