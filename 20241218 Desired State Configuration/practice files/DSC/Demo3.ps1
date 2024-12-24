Configuration Demo3
{
    Import-DscResource -ModuleName PsDesiredStateConfiguration
    ForEach($Node in $AllNodes)
    {
        Node $Node.NodeName
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
}