<#
STEP 6
Convert to New Syntax
#>

$ContainerName = 'tempdev'
$DeltaPath = 'C:\ProgramData\NAVContainerHelper\Migration\DELTA_NEW'
$AlPath = 'C:\ProgramData\NAVContainerHelper\Migration\AL'
$ExtensionStartId = 50000

$Session = Get-NAVContainerSession -containerName $ContainerName
Invoke-Command -Session $Session -ScriptBlock {
    param(
        $DeltaPath, $AlPath, $ExtensionStartId 
    ) 

    Write-Host "Migration to AL"
    $Arguments = @("--source=$DeltaPath", "--target=$AlPath", "--rename", "--extentionStartId $ExtentionStartId")

    Start-Process "$NAVClientPath\tet2al.exe" -$Arguments

} -ArgumentList $DeltaPath, $AlPath, $ExtensionStartId
        
        
