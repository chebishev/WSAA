@{
    AllNodes = @(
        @{ NodeName = "SERVER1" ; WindowsFeatures = @("Web-Server", "Web-Mgmt-Tools") },
        @{ NodeName = "SERVER2" ; WindowsFeatures = @("Web-Server") }
    )
}