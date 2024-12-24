Configuration WebServer
{
    param ($Server = 'SERVER2')
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Node $Server
    {
        Script WebSrv
        {
            TestScript = {
                $result = $true
                
                if (Get-WindowsFeature -Name Web-Server | Select -Property Installed)
                {
                    Write-Verbose "Web-Server is feature found."
                }
                else
                {
                    Write-Verbose "Web-Server feature NOT found."
                    $result = $false
                }
                if (Test-Path -Path C:\inetpub\wwwroot\index.html -PathType Leaf){
                    Write-Verbose "File C:\inetpub\wwwroot\index.html found."
                    if (Select-String -Path C:\inetpub\wwwroot\index.html -Pattern "Running on $using:Server"){
                        Write-Verbose "Contains what is expected."
                    }
                    else
                    {
                        Write-Verbose "Does NOT contain what is expected."
                        $result = $false
                    }
                }
                else 
                {
                    Write-Verbose "File C:\inetpub\wwwroot\index.html NOT found."
                    $result = $false
                }
                return $result
            }
            GetScript = {

            }

            SetScript = {
                Write-Verbose "Installing the web-server feature"
                Add-WindowsFeature -Name Web-Server
                Write-Verbose "Creating a custom page at C:\inetpub\wwwroot\index.html"
                New-Item -ItemType File -Path C:\inetpub\wwwroot\index.html -Force
                Write-Verbose "Writing to the custom page at C:\inetpub\wwwroot\index.html"
                Set-Content -Path C:\inetpub\wwwroot\index.html -Value "Running on $using:Server"
            }
        }
    }
}