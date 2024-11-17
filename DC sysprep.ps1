# PowerShell script to run sysprep
$sysprepPath = "C:\Windows\System32\Sysprep"
# Check if sysprep.exe exists at the path
if (Test-Path "$sysprepPath\sysprep.exe") {
    # Run sysprep with the /oobe, /generalize, and /shutdown options
    Start-Process -FilePath "$sysprepPath\sysprep.exe" -ArgumentList "/oobe", "/generalize", "/shutdown" -Wait
    Write-Host "Sysprep has completed. The system will now shut down." -ForegroundColor Green
} else {
    Write-Host "sysprep.exe not found at the specified path." -ForegroundColor Red
}
