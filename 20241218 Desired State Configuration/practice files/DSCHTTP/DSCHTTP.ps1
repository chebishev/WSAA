Configuration DSCHTTP
{
    param
    (
        [string[]]$NodeName = "SERVER1",

        [ValidateNotNullOrEmpty()]
        [string] $RegistrationKey = "Super secret key. we should use GUID instead"
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName XPSDesiredStateConfiguration
    Import-DscResource -ModuleName NetworkingDSC

    Node $NodeName
    {
        WindowsFeature DSCServiceFeature
        {
            Name = "DSC-Service"
            Ensure = "Present"
        }

        XDSCWebService PSDSCPullServer
        {
            Ensure = "Present"
            EndpointName = "PSDSCPullServer"
            Port = 8080
            PhysicalPath = "$env:SystemDrive\inetpub\PSDSCPullServer"
            CertificateThumbPrint = "AllowUnencryptedTraffic"
            ModulePath = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Modules"
            ConfigurationPath = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration"
            ConfigureFirewall = $false
            State = "Started"
            DependsOn = "[WindowsFeature]DSCServiceFeature"
            RegistrationKeyPath = "$env:PROGRAMFILES\WindowsPowerShell\DscService"
            UseSecurityBestPractices = $false
        }

        File RegistrationKeyFile
        {
            Ensure = "Present"
            Type = "File"
            DestinationPath = "$env:PROGRAMFILES\WindowsPowerShell\DscService\RegistrationKeys.txt"
            Contents = $RegistrationKey
        }

        Firewall PSDSCPullServerRule {
            Ensure = "Present"
            Name = "DSC_PullServer_Port_8080"
            DisplayName = "DSC_PullServer_Port_8080"
            Group = "DSC PullServer"
            Enabled = "True"
            Direction = "Inbound"
            Action = "Allow"
            Protocol = "TCP"
            LocalPort = 8080
            DependsOn = "[XDSCWebService]PSDSCPullServer"
        }
    }
}