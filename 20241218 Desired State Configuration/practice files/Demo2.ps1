Configuration Demo2
{
    Import-DscResource -ModuleName PsDesiredStateConfiguration
    Node SERVER1
    {
        File ReadMe
        {
            Ensure = "Present"
            Contents = "THis file was created with DSC."
            Type = "File"
            DestinationPath = "C:\Readme.txt"
        }
    }
    Node SERVER2
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