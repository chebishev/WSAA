Configuration Demo4
{
    Import-DscResource -ModuleName PsDesiredStateConfiguration
    ForEach($Node in $AllNodes)
    {
        Node $Node.NodeName
        {
            ForEach($Feature in $Node.WindowsFeatures)
            {
                WindowsFeature $Feature
                {
                    Name = $Feature
                    Ensure = "Present"
                }
            }
            File IndexPage
            {
                Ensure = "Present"
                Contents = "Running on " + $Node.NodeName
                Type = "File"
                DestinationPath = "C:\inetpub\wwwroot\index.html"
            }
        }
     }
}