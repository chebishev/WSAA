Configuration Demo1
{
    Import-DscResource -ModuleName PsDesiredStateConfiguration
    Node 'localhost'
    {
        File HelloWorld
        {
            DestinationPath = "C:\Temp\HelloWorld.txt"
            Ensure = "Present"
            Contents = "Hello World from DSC!"
        }    
    }
}