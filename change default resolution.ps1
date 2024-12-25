# Get all Hyper-V VMs
$VMs = Get-VM

# Loop through each VM and set the video resolution
foreach ($VM in $VMs) {
    Set-VMVideo -VMName $VM.Name -HorizontalResolution 1280 -VerticalResolution 720 -ResolutionType Single
}
