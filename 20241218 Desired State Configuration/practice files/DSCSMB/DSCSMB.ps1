Configuration DSCSMB
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName ComputerManagementDSC
    Import-DscResource -ModuleName cNtfsAccessControl

    Node SERVER1
    {
        File CreateFolder
        {
            DestinationPath = "C:\DscSmbShare"
            Type = "Directory"
            Ensure = "Present"
        }

        SMBShare CreateShare
        {
            Name = "DscSmbShare"
            Path = "C:\DscSmbShare"
            Ensure = "Present"
            FullAccess = "WSAA\Domain Admins"
            ReadAccess = @("WSAA\SERVER2$", "WSAA\SERVER3$")
            FolderEnumerationMode = "AccessBased"
            DependsOn = "[File]CreateFolder"
        }

        cNtfsPermissionEntry PermissionSetSERVER2
        {
            Ensure = "Present"
            Path = "C:\DscSmbShare"
            Principal = "WSAA\SERVER2$"
            AccessControlInformation = @(
                cNtfsAccessControlInformation
                {
                    AccessControlType = "Allow"
                    FileSystemRights = "ReadAndExecute"
                    Inheritance = "ThisFolderSubfoldersAndFiles"
                    NoPropagateInherit = $false
                }
            )
            DependsOn = "[File]CreateFolder"
        }

        cNtfsPermissionEntry PermissionSetSERVER3
        {
            Ensure = "Present"
            Path = "C:\DscSmbShare"
            Principal = "WSAA\SERVER3$"
            AccessControlInformation = @(
                cNtfsAccessControlInformation
                {
                    AccessControlType = "Allow"
                    FileSystemRights = "ReadAndExecute"
                    Inheritance = "ThisFolderSubfoldersAndFiles"
                    NoPropagateInherit = $false
                }
            )
            DependsOn = "[File]CreateFolder"
        }
    }
}