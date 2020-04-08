<#
STEP 3
Apply Delta to database & export as new syntax
#>

$ContainerName = 'tempdev'
$DeltaPath = 'C:\ProgramData\NAVContainerHelper\Migration\DELTA'
$OriginalPath = 'C:\ProgramData\NAVContainerHelper\Migration\ORIGINAL'
$WorkingPath = 'C:\ProgramData\NAVContainerHelper\Migration\ApplyDelta'
$ApplieDeltaPath = 'C:\ProgramData\NAVContainerHelper\Migration\ApplieDelta'

$Session = Get-NAVContainerSession -containerName $ContainerName
Invoke-Command -Session $Session -ScriptBlock {
    param(
        $DeltaPath, $OriginalPath, $WorkingPath, $ApplieDeltaPath 
    ) 

    Write-Host "Reset Path"
    $null = Remove-Item -Path $WorkingPath -Recurse -Force -ErrorAction SilentlyContinue
    $null = New-Item -Path $WorkingPath -ItemType Directory
    $null = Remove-Item -Path $ApplieDeltaPath -Recurse -Force -ErrorAction SilentlyContinue
    $null = New-Item -Path $ApplieDeltaPath -ItemType Directory

    Write-Host "Copy corresponding original files to working-directory"
    Get-ChildItem -Path $DeltaPath | % {
        Get-ChildItem $OriginalPath | where BaseName -eq $ .BaseName | Copy-Item -Destination $WorkingPath
    }

    Write-Host "Apply Deltas"
    $UpdateResalt =
    Update-NAVApplicationObject
       -DeltaPath $DeltaPath
       -TargetPath $WorkingPath
       -ResultPath $ApplieDeltaPath
       -Force 
      
    Write-Host "Import Deltas      "
    $DatabaseName = ((Get-NAVServerConfiguration -ServerInstace NAV -AsXml).configuration.appSettings.add | Where )
    Import-NAVApplicationObject
         -DatabaseName $DatabaseName
         -Path "$AppliedDeltaPath\*.txt"
         -LogPath "$WorkingPath\ImportLog"
         -ImportAction Overwrite
         -SynchronizeSchemaChanges Force 
         -Confirm:$false

    Write-Host "Compile Uncompiled"
    Compile-NAVApplicationObject
         -DatabaseName $DatabaseName
         -LogPath "$WorkingPath\CompileLog"
         -Recompile
         -Filter "Compiled=0"     

  } -ArgumentList $DeltaPath, $OriginalPath, $WorkingPath, $ApplieDeltaPath