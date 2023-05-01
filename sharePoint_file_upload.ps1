Function Upload-LargeFile($FilePath, $LibraryName, $FileChunkSize=10)
{
    Try {
        #Get File Name
        $FileName = [System.IO.Path]::GetFileName($FilePath)
        $UploadId = [GUID]::NewGuid()
 
        #Get the folder to upload
        $Library = $Ctx.Web.Lists.GetByTitle($LibraryName)
        $Ctx.Load($Library)
        $Ctx.Load($Library.RootFolder)
        $Ctx.ExecuteQuery()
 
        $BlockSize = $FileChunkSize * 1024 * 1024 
        $FileSize = (Get-Item $FilePath).length
        If($FileSize -le $BlockSize)
        {
            #Regular upload
            $FileStream = New-Object IO.FileStream($FilePath,[System.IO.FileMode]::Open)
            $FileCreationInfo = New-Object Microsoft.SharePoint.Client.FileCreationInformation
            $FileCreationInfo.Overwrite = $true
            $FileCreationInfo.ContentStream = $FileStream
            $FileCreationInfo.URL = $FileName
            $Upload = $Docs.RootFolder.Files.Add($FileCreationInfo)
            $ctx.Load($Upload)
            $ctx.ExecuteQuery()
        }
        Else
        {
            #Large File Upload in Chunks
            $ServerRelativeUrlOfRootFolder = $Library.RootFolder.ServerRelativeUrl
            [Microsoft.SharePoint.Client.File]$Upload
            $BytesUploaded = $null 
            $Filestream = $null
            $Filestream = [System.IO.File]::Open($FilePath, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::ReadWrite)
            $BinaryReader = New-Object System.IO.BinaryReader($Filestream)
            $Buffer = New-Object System.Byte[]($BlockSize)
            $LastBuffer = $null
            $Fileoffset = 0
            $TotalBytesRead = 0
            $BytesRead
            $First = $True
            $Last = $False
 
            #Read data from the file in blocks
            While(($BytesRead = $BinaryReader.Read($Buffer, 0, $Buffer.Length)) -gt 0)
            { 
                $TotalBytesRead = $TotalBytesRead + $BytesRead 
                If ($TotalBytesRead -eq $FileSize)
                { 
                    $Last = $True
                    $LastBuffer = New-Object System.Byte[]($BytesRead)
                    [Array]::Copy($Buffer, 0, $LastBuffer, 0, $BytesRead) 
                }
                If($First)
                { 
                    #Create the File in Target
                    $ContentStream = New-Object System.IO.MemoryStream
                    $FileCreationInfo = New-Object Microsoft.SharePoint.Client.FileCreationInformation
                    $FileCreationInfo.ContentStream = $ContentStream
                    $FileCreationInfo.Url = $FileName
                    $FileCreationInfo.Overwrite = $true
                    $Upload = $Library.RootFolder.Files.Add($FileCreationInfo)
                    $Ctx.Load($Upload)
 
                    #Start FIle upload by uploading the first slice
                    $s = new-object System.IO.MemoryStream(, $Buffer) 
                    $BytesUploaded = $Upload.StartUpload($UploadId, $s)
                    $Ctx.ExecuteQuery() 
                    $fileoffset = $BytesUploaded.Value 
                    $First = $False 
                } 
                Else
                { 
                    #Get the File Reference
                    $Upload = $ctx.Web.GetFileByServerRelativeUrl($Library.RootFolder.ServerRelativeUrl + [System.IO.Path]::AltDirectorySeparatorChar + $FileName);
                    If($Last)
                    {
                        $s = [System.IO.MemoryStream]::new($LastBuffer)
                        $Upload = $Upload.FinishUpload($UploadId, $fileoffset, $s)
                        $Ctx.ExecuteQuery()
                        Write-Host "File Upload completed!" -f Green                       
                    }
                    Else
                    {
                        #Update fileoffset for the next slice
                        $s = [System.IO.MemoryStream]::new($buffer)
                        $BytesUploaded = $Upload.ContinueUpload($UploadId, $fileoffset, $s)
                        $Ctx.ExecuteQuery()
                        $fileoffset = $BytesUploaded.Value
                    }
                }
            }
        }
    }
    Catch {
        Write-Host $_.Exception.Message -ForegroundColor Red
    }
    Finally {
        If($Filestream -ne $null)
        {
            $Filestream.Dispose()
        }
    }
}


$URL = "https://altanjoloogroupmn.sharepoint.com/sites/it77"
$TargetFolderRelativeURL ="Shared Documents/Backups/"
$sourceFolder = "E:\"
$logout = 'F:\sharepointlog.txt'
(Get-Date).ToString() + " script started" | out-file -FilePath $logout -append
#CREDENTIAL
$AdminAccount = "enkhtur@altanjoloo.mn"
$AdminPass = "Yanjika123$"
$SecPwd = $(ConvertTo-SecureString $AdminPass -asplaintext -force) 
$Cred = New-Object System.Management.Automation.PSCredential ($AdminAccount, $SecPwd)

Import-Module SharePointPnPPowerShellOnline
Connect-PnPOnline -url $URL -Credentials ($cred)
$Ctx = Get-PnPContext
$hour = 4;
$minute = 40;
$stime = 10;
$loopStatus = 0;
while(1 -eq 1){
	$current_date = Get-Date;
	if($current_date.Hour -eq $hour -and $current_date.Minute -eq $Minute -and $loopStatus -eq 0){
		(Get-Date).ToString() + " Today loop starting ..." | out-file -FilePath $logout -append
		#subfolders create
$File = Get-ChildItem -Path $sourceFolder -Recurse -Directory -Force -ErrorAction SilentlyContinue | Select-Object FullName
foreach($f in $File) {
    Write-Output $f 
    $f = $f.FullName
    $ve = ($f -split "\\").Length
    $foldername = ($f -split "\\")[$ve-1] 
    if($f.IndexOf("\") -eq $f.LastIndexOf("\")){
        $folderdirectory = $TargetFolderRelativeURL
        Add-PnPFolder -Name $foldername -Folder $folderdirectory
    }else{
        $folderdirectory = $f.Substring(3)
        $urldirectory=$folderdirectory.Substring(0,$folderdirectory.Length-$foldername.Length-1)
        $urldirectory=$urldirectory.Replace("\","/")
        $urldirectory = $TargetFolderRelativeURL+"/"+$urldirectory
        Write-Output "folder: " $foldername
        Write-Output "url: "$urldirectory
        Add-PnPFolder -Name $foldername -Folder $urldirectory
    }
}

$counter = 0;
$Files = Get-ChildItem $sourceFolder -Recurse | % { $_.FullName }
foreach($File in $Files) {
    $begindate = (get-date)
    $tempdate = (Get-Item $File).CreationTime
    $lastdate = (Get-Item $File).LastWriteTime
    $tmp1 = ($File -split "\\")[-1]
    $tmp1 = $tmp1.Replace("\\","\");
    if(($begindate.Day -eq $tempdate.Day -and $begindate.Month -eq $tempdate.Month -and $tempdate.Year -eq $begindate.Year) -or ((get-date).day -eq $lastdate.day -and $begindate.Month -eq $lastdate.Month -and $lastdate.Year -eq $begindate.Year)){
            $tmp2 = $File.Substring($sourceFolder.Length)
            $tmp2 = $tmp2.Substring(0,$tmp2.LastIndexOf("\"))
            $tmp2 = $tmp2.Replace('\','/')
            $target = $TargetFolderRelativeURL +"/"+ $tmp2  # subfolders url path
            $target = $target.Replace("//","/");
            if(Test-Path -Path $File -PathType Leaf){
                $filesize = (Get-Item -Path $File).Length/1MB
                if($filesize -lt 100){ # 100 MB aas baga zone
                try {
                    
                    Add-PnPFile -Path $File -Folder $target   #CREATING SUB FOLDERS
                    Write-Output $tmp1+" file uploaded" -f Green
                    $counter++;
                    (Get-Date).ToString() + "File uploaded: " + $file +" Counter: "+ $counter | out-file -FilePath $logout -append
                }
                catch {
                    Write-Output $File "failed"
                    (Get-Date).ToString() + "File failed: " + $file +" Counter: "+ $counter | out-file -FilePath $logout -append
                }}
                else{ # LARGE FILE COPy ZONE
                    try {
                        Upload-LargeFile -FilePath $File -LibraryName "Documents" 
                        $counter++;
                        (Get-Date).ToString() + "Large file uploaded: " + $file +" Counter: "+ $counter | out-file -FilePath $logout -append
                        $size = (Get-Item -Path $file).Length/1MB
                        $size = [math]::Round($size);
                        (Get-Date).ToString() + "file size: " + $size +"MB" | out-file -FilePath $logout -append
                    }
                    catch {
                        (Get-Date).ToString() + "Large file failed: " + $file +" Counter: "+ $counter | out-file -FilePath $logout -append
                    }
                    $tmp3 = $File.Substring($sourceFolder.length)
                    $tmp3 = $tmp3.replace("\","/")
                
                $file_name_only = ($file -split "\\")[($file -split "\\").Length-1]
                $subfolders_only = $tmp3.Replace($file_name_only,""); $subfolders_only = $subfolders_only.Replace("\","/")   ; $subfolders_only=$subfolders_only.Substring(0,$subfolders_only.Length-1)
                $Source = "/Shared Documents/" + (Split-Path $file -Leaf)

                $Target = $TargetFolderRelativeURL +$tmp3
                $Target = $Target.Replace("//","/");    
                    Move-PnPFile $Source -TargetUrl $Target -Force
                    (Get-Date).ToString() + "Large file moved: " + $file +" Counter: "+ $counter  + " Moved target name: " +$target | out-file -FilePath $logout -append 
                }
                
            }
             
    }
	}	

#endregion
		(Get-Date).ToString() + " Today loop END" | out-file -FilePath $logout -append
		$loopStatus = 1;
		
	}
	if($current_date.hour -eq 0 -and $current_date.Minute -eq 0){
		$loopStatus = 0;
		(Get-Date).ToString() + " Loop Status 0 bolloo." | out-file -FilePath $logout -append
		$counter = 0;
	}
	start-sleep -Seconds $stime
}


