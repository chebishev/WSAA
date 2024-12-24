Configuration ConfigurationOne
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node localhost
    {
        File ReadMe
        {
            Ensure = "Present"
            Contents = "THis file was created with DSC."
            Type = "File"
            DestinationPath = "C:\ConfigurationOne.txt"
        }
    }
}