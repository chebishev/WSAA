[DSCLocalConfigurationManager()]
Configuration PullClientConfigIDHTTP
{
    ForEach($Node in $AllNodes)
    {
        Node $Node.NodeName
        {
            Settings
            {
                RefreshMode = "Pull"
                ConfigurationID = ''
                RefreshFrequencyMins = 30
                RebootNodeIfNeeded = $true
                ConfigurationMode = "ApplyAndAutoCorrect"
            }

            ConfigurationRepositoryWeb SERVER1
            {
                ServerURL = "http://SERVER1:8080/PSDSCPullServer.svc"
                AllowUnsecureConnection = $true
                RegistrationKey = "Super secret key. we should use GUID instead"
                ConfigurationNames = @("ConfigurationOne")
            }

            ResourceRepositoryWeb SERVER1 
            {
                ServerURL = "http://SERVER1:8080/PSDSCPullServer.svc"
                AllowUnsecureConnection = $true
            }
        }
    }
}