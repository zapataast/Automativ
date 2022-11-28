$URL = "https://altanjoloogroupmn.sharepoint.com/sites/it77"
$TargetFolderRelativeURL ="/Shared Documents/Backups/Test"
$sourceFolder = "D:\sharepoint_sync"

$Cred = Get-Credential
Import-Module SharePointPnPPowerShellOnline
Connect-PnPOnline -url $URL
#region subfolders create 
<#
$get_all_sub_folders = Get-ChildItem -Path $sourceFolder -Recurse -Directory -Force -ErrorAction SilentlyContinue | Select-Object FullName
$main_path = ($sourceFolder -split "\\")[-1]
foreach($f in $get_all_sub_folders){
    $tmp1 = ($f.FullName -split "\\")[-1]   # subfolders name creating
    if(($f.FullName -split "\\")[-2] -eq $main_path){
        Add-PnPFolder -Name $tmp1 -Folder $TargetFolderRelativeURL #CREATING SUB FOLDERS
    }else{
        $tmp2 = $f.FullName.Substring($sourceFolder.Length)
        $tmp2 = $tmp2.Substring(1,$tmp2.Length-$tmp1.Length-2)
        $tmp2 = $tmp2.Replace('\','/')
        $target = $TargetFolderRelativeURL + "/" + $tmp2  # subfolders url path
        Add-PnPFolder -Name $tmp1 -Folder $target   #CREATING SUB FOLDERS
        #Start-Sleep -Seconds 1
    }
}
#>
#endregion
#region subfiles upload
$Files = Get-ChildItem $sourceFolder -Recurse | % { $_.FullName }
foreach($File in $Files) {
    $tempdate = (Get-Item $File).CreationTime
    #Write-Output $tempdate
    $tmp1 = ($File -split "\\")[-1]
    #if((Get-Date).Day -eq $tempdate.Day){
        if(($File -split "\\")[-2] -eq $main_path)
        {
            if(Test-Path -Path $File -PathType Leaf){
                try {
                    Add-PnPFile -Path $File -Folder $TargetFolderRelativeURL -ErrorAction Stop 
                    Write-Output $File "file uploaded"
                }
                catch {
                    Write-Output $File "file passed"
                }
                
            }
        }else{
            $tmp2 = $File.Substring($sourceFolder.Length)
            $tmp2 = $tmp2.Substring(1,$tmp2.Length-$tmp1.Length-2)
            $tmp2 = $tmp2.Replace('\','/')
            $target = $TargetFolderRelativeURL + "/" + $tmp2  # subfolders url path
            if(Test-Path -Path $File -PathType Leaf){
                try {
                    Add-PnPFile -Path $File -Folder $target   #CREATING SUB FOLDERS
                    Write-Output $tmp1+"file uploaded"
                }
                catch {
                    Write-Output $File "passed"
                }
                
            }
        }        
#    }
}
#endregion

