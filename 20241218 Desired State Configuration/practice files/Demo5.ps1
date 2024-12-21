[DscLocalConfigurationManager()]
Configuration Demo5
{
    ForEach($Node in $AllNodes){
        Node $Node.NodeName
        {
            Settings
            {
                ConfigurationMode = "ApplyAndAutoCorrect"
                ConfigurationModeFrequencyMins = 15
                RefreshFrequencyMins = 30
            }
        }
    }
}