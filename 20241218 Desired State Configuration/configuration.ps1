Configuration WebServer
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName ComputerManagementDSC

    File CreateFolder 
    {
    DestinationPath = "C:\HTMLShare"
    Type            = "Directory"
    Ensure          = "Present"
    }
    
    SMBShare CreateShare
    {
        Name            = "IndexShare"
        Path            = "C:\HTMLShare"
        FullAccess      = "WSAA\Domain Admins"
        ReadAccess      = @("WSAA\SERVER1$", "WSAA\SERVER2$")
        FolderEnumerationMode = "AccessBased"
        Ensure          = "Present"
        DependsOn       = "[File]CreateFolder"
    }

    File IndexPage {
        Ensure          = "Present"
        Contents        = "Hello, I am homework custom index file"
        Type            = "File"
        DestinationPath = "C:\HTMLShare\index.html"
        DependsOn = "[File]CreateFolder"
    }
    ForEach ($Node in $AllNodes) {
        Node $Node.NodeName
        {
            ForEach ($Feature in $Node.WindowsFeatures) {
                WindowsFeature $Feature {
                    Name   = $Feature
                    Ensure = "Present"
                }
            }
            File CopyIndexToServer_$($Node.NodeName) {
                    DestinationPath = "C:\inetpub\wwwroot\index.html"
                    SourcePath      = "\\DC\IndexShare\index.html"
                    Ensure          = "Present"
                    DependsOn       = "[WindowsFeature]$Feature"
                }
        }
    }
}