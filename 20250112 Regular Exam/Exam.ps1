Configuration Exam
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName ComputerManagementDSC

    Node DC
    {
        File CreateFolder
        {
            DestinationPath = "C:\Exam"
            Type = "Directory"
            Ensure = "Present"

        }

        SMBShare CreateShare
        {
            Name = "Exam"
            Path = "C:\Exam"
            ReadAccess = @("WSAA\N1$", "WSAA\N2$")
            Ensure = "Present"
            DependsOn = "[File]CreateFolder"
        }
        # This one gives you the points from the task:
        # File IndexPageN1
        # {
        #     Ensure = "Present"
        #     Contents = "Running on N1"
        #     Type = "File"
        #     DestinationPath = "C:\Exam\index-n1.html"
        # }

        # File IndexPageN2
        # {
        #     Ensure = "Present"
        #     Contents = "Running on N2"
        #     Type = "File"
        #     DestinationPath = "C:\Exam\index-n2.html"
        # }
        
        # This one doesn't give you the points from the task:
        ForEach($Node in $AllNodes)
        {
            $lowerCaseNodeName = $Node.NodeName.ToLower()
            File "IndexPage_$($Node.NodeName)"
            {
                Ensure = "Present"
                Contents = "Running on $Node.NodeName"
                Type = "File"
                DestinationPath = "C:\Exam\index-$lowerCaseNodeName.html"
            }
        }
    }
    ForEach($Node in $AllNodes)
    {
        Node $Node.NodeName
        {
            ForEach ($Feature in $Node.WindowsFeatures)
            {
                WindowsFeature $Feature
                {
                Name = $Feature
                Ensure = "Present"
                }
            }
            File CopyIndexFromLocalhostToNode
            {
                Ensure ="Present"
                SourcePath = "\\DC\Exam\index-$Node.NodeName.ToLower().html"
                DestinationPath = "C:\inetpub\wwwroot\index.html"
                DependsOn = "[WindowsFeature]$Feature"
            }
            File "CreateVersionFile_$($Node.NodeName)"
            {
                Ensure = "Present"
                Contents = "latest"
                Type = "File"
                DestinationPath = "C:\version.txt"

            }
            
        }
    }
}