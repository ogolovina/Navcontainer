<#
STEP 5
Create Deltas in New Syntax
#>

$ContainerName = 'tempdev'
$OriginalPath = 'C:\ProgramData\NAVContainerHelper\Migration\ORIGINAL_NEW'
$ModifiedPath = 'C:\ProgramData\NAVContainerHelper\Migration\MODIFIED_NEW'
$DeltaPath = 'C:\ProgramData\NAVContainerHelper\Migration\DELTA_NEW'

$Session = Get-NAVContainerSession -containerName $ContainerName
Invoke-Command -Session $Session -ScriptBlock {
    param(
        $OriginalPath, $ModifiedPath, $DeltaPath 
    ) 

    $null = Remove-Item -Path $DeltaPath -Recurse -Force -ErrorAction SilentlyContinue
    $null = Remove-Item -Path $DeltaPath -ItemType Directory
    
    Write-Host "Create delta in new syntax"
    $CompareResult =
        Compare-NAVApplicationObject
             -OriginalPath $OriginalPath
             -ModifiedPath $ModifiedPath
             -DeltaPath $DeltaPath
             -ExportToNewSyntax

} -ArgumentList $Filter, $ModifiedPath, $ModifiedNewSyntaxPath    
        
        
