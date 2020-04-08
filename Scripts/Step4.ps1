<#
STEP 4
Export modified objects (normal and new syntax)
#>

$ContainerName = 'tempdev'
$ModifiedPath = 'C:\ProgramData\NAVContainerHelper\Migration\MODIFIED'
$ModifiedNewSyntaxPath = 'C:\ProgramData\NAVContainerHelper\Migration\MODIFIED_NEW'
$Filter = ''

$Session = Get-NAVContainerSession -containerName $ContainerName
Invoke-Command -Session $Session -ScriptBlock {
    param(
        $Filter, $ModifiedPath, $ModifiedNewSyntaxPath 
    ) 

    $DatabaseName = ((Get-NAVServerConfiguration -ServerInstance NAV -AsXml).configuration.appSettings.add | where)

    Write-Host "Export Objects to normal syntax"
    Export-NAVApplicationObject
        -DatabaseName $DatabaseName
        -Path "$ModifiedPath.txt"
        -LogPath "$ModifiedPath.log"
        -ExportTxtSkipUnlicensed
        -Filter $Filter

    Write-Host "Export Objects to new syntax"
    Export-NAVApplicationObject
        -DatabaseName $DatabaseName
        -Path "$ModifiedNewSyntaxPath.txt"
        -LogPath "$ModifiedNewSyntaxPath.log"
        -ExportTxtSkipUnlicensed
        -Filter $Filter 
        -ExportToNewSyntax  
        
    Write-Host "Split the objects"
    Split-NAVApplicationObjectFile
        -Source "$ModifiedPath.txt"
        -Destination $ModifiedPath  
        
    Split-NAVApplicationObjectFile
        -Source "$ModifiedNewSyntaxPath.txt"
        -Destination $ModifiedNewSyntaxPath

    Write-Host "Remove Full Fiels"
    Remove-Item -Path "$ModifiedPath.txt"
    Remove-Item -Path "$ModifiedNewSyntaxPath.txt"
    
} -ArgumentList $Filter, $ModifiedPath, $ModifiedNewSyntaxPath    
        
        
