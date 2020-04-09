<#
STEP 2
Export Original objects (normal and new syntax)
#>

$ContainerName = 'tempdev'
$Filter = ''
$OriginalPath = 'C:\ProgramData\NAVContainerHelper\Migration\ORIGINAL'
$OriginalNewSyntaxPath = 'C:\ProgramData\NAVContainerHelper\Migration\ORIGINAL_NEW'

$Session = Get-NAVContainerSession -containerName $ContainerName
Invoke-Command -Session $Session -ScriptBlock {
    param(
        $Filter, $OriginalPath, $OriginalNewSyntaxPath 
    ) 

    $DatabaseName = ((Get-NAVServerConfiguration -ServerInstance NAV -AsXml).configuration.appSettings.add | where)

    Write-Host "Export Objects to normal syntax"
    Export-NAVApplicationObject
        -DatabaseName $DatabaseName`
        -Path "$OriginalPath.txt"`
        -LogPath "$OriginalPath.log"`
        -ExportTxtSkipUnlicensed`
        -Filter $Filter

    Write-Host "Export Objects to new syntax"
    Export-NAVApplicationObject
        -DatabaseName $DatabaseName`
        -Path "$OriginalPath.txt"`
        -LogPath "$OriginalPath.log"`
        -ExportTxtSkipUnlicensed`
        -Filter $Filter   
        
    Write-Host "Split the objects"
    Split-NAVApplicationObjectFile
        -Source "$OriginalPath.txt"`
        -Destination $OriginalPath

    Split-NAVApplicationObjectFile
        -Source "$OriginalNewSyntaxPath.txt"`
        -Destination $OriginalNewSyntaxPath

    Write-Host "Remove Full Files"
    Remove-Item -Path "$OriginalPath.txt"`
    Remove-Item -Path "$OriginalNewSyntaxPath.txt"


} -ArgumentList $Filter, $OriginalPath, $OriginalNewSyntaxPath