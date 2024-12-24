[DSCLocalConfigurationManager()]
Configuration PullClientConfigIDSMB
{
    ForEach($Node in $AllNodes)
    {
        Node $Node.NodeName
        {
            Settings
            {
                RefreshMode = "Pull"
                ConfigurationID = '1896cbd0-ee0b-42b4-a3b9-3b4cdee1be43'
                RefreshFrequencyMins = 30
                RebootNodeIfNeeded = $true
            }

            ConfigurationRepositoryShare SMBPullServer
            {
                SourcePath = '\\SERVER1\DscSmbShare'
            }
        }
    }
}