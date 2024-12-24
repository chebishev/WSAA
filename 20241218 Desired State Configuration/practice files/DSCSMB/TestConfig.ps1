Configuration TestConfig
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node localhost
    {
        WindowsFeature TFTPClient
        {
            Name = "TFTP-Client"
            Ensure = "Present"
        }

        File Result
        {
            Ensure = "Present"
            Contents = "TFTP Client has been installed"
            Type = "File"
            DestinationPath = "C:\Result.txt"
            DependsOn = "[WindowsFeature]TFTPClient" 
        }
    }
}