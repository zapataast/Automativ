
$URL = "https://altanjoloogroupmn.sharepoint.com/sites/it77"
$TargetFolderRelativeURL ="/Shared Documents/Backups"
$sourcefile = "D:\sharepoint_sync\gg.txt"


$Cred = Get-Credential
Import-Module SharePointPnPPowerShellOnline
Connect-PnPOnline -url $URL

$Files = Get-ChildItem "D:\sharepoint_sync" -Recurse | % { $_.FullName }
foreach($File in $Files) {
    $tempdate = (Get-Item $File).CreationTime
    #Write-Output $tempdate
    if((Get-Date).Day -eq $tempdate.Day){
        Add-PnPFile -Path $temppath -Folder $TargetFolderRelativeURL -ErrorAction Stop
    }
    Write-Output $File
    #Add-PnPFile -Path $sourcefile -Folder $TargetFolderRelativeURL -ErrorAction Stop
}

$gg = Get-ChildItem D:*.txt -Filter *.txt -Recurse | % { $_.FullName }