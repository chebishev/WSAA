Configuration Demo2P
{
    Param ($server = 'SERVER1')
    Import-DscResource -ModuleName PsDesiredStateConfiguration
    Node $server
    {
     File ReadMe
        {
            Ensure = "Present"
            Contents = "THis file was created with DSC."
            Type = "File"
            DestinationPath = "C:\Readme.txt"
        }
    }
}