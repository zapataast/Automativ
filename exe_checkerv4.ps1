$self_file = '\\192.168.0.253\Install\2.System Restore\6checker.exe'
if(Test-Path 'D:\install'){
    #nothing
}else{
    New-Item -Path 'D:\' -Name 'install' -ItemType 'directory'
}
$ERP_folder = '\\192.168.0.253\Install\7.FINANCE PROGRAM\6.0 final 20190808' 
$retail_shortcut_path = $ERP_folder + '\Information\' + 'Retial 6.0.lnk'
$sankhuu_shortcut_path = $ERP_folder + '\Information\' + 'Sankhuu 6.0.lnk'
$desko = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::Desktop)
$retail_shortcut_path = $ERP_folder + '\Information\' + 'Retial 6.0.lnk'
$sankhuu_shortcut_path = $ERP_folder + '\Information\' + 'Sankhuu 6.0.lnk'

$Desktop_retial = $desko + '\Retial 6.0.lnk'
$Desktop_sankhuu = $desko + '\Sankhuu 6.0.lnk'

Copy-Item -Path $self_file -Destination 'D:\install\6checker.exe' -Recurse

$interval_time = 1; #86400;
$time_sleep = 0
Copy-Item -Path $self_file -Destination 'D:\install\6checker.exe' -Recurse
$start_time = Get-Date
$standart_folder_size = 100 #MB
$DesktopPath = '\\192.168.0.253\Install\7.FINANCE PROGRAM\6.0 final 20190808\retail 6.0'
$path_backup = 'D:\install\retail 6.0'
$new_copy = 0
$sa_recopy = 0
$re_copy = 0
if(Test-Path $path_backup){
    #Rename-Item $path_backup 'D:\backup2' -Force
    #New-Item -Path 'D:\' -Name 'backup' -ItemType 'directory'
}else{
    Write-Output 'baixgvi'
    New-Item -Path 'D:\install\' -Name 'retail 6.0' -ItemType 'directory'
}
if(Test-Path 'D:\install\sankhuu 6.0'){
    #Rename-Item $path_backup 'D:\backup2' -Force
    #New-Item -Path 'D:\' -Name 'backup' -ItemType 'directory'
}else{
    Write-Output 'baixgvi'
    New-Item -Path 'D:\install\' -Name 'sankhuu 6.0' -ItemType 'directory'
}
$T = 'True'
while ($T -eq 'True') {
    $data1 = Get-ChildItem $DesktopPath -name
    $data1_len = $data1.Count-1
    if($data1_len -eq 0){
        $data1 = @($data1, 'white')
    }
    Write-Output '---------------- Cycle starting------------------'
    $start_time = Get-Date ; Write-Output $start_time
    Write-Output $re_copy, $new_copy
    Start-Sleep -Seconds $time_sleep

    Remove-Item -Path $Desktop_retial
    Remove-Item -Path $Desktop_sankhuu

    for($i=0; $i -le $data1_len; $i++){
        $path = $DesktopPath + '\' + $data1[$i] 
            if([System.IO.File]::Exists($path)){
                Write-Output 'file bna'
                $path1 = $path_backup + '\' + $data1[$i]   
                if([System.IO.File]::Exists($path1)){
                    Write-Output 'd dr bna'  # энд он сараар шалгах процесс байна
                    $tmp_time = (Get-Item $path1).LastWriteTime
                    $tmp_time_day = $tmp_time.Day
                    $tmp_time_hour = $tmp_time.Hour
                    $tmp_time_min = $tmp_time.Minute
                    $tmpd = (Get-Item $path).LastWriteTime
                    $tmpd_day = $tmpd.Day
                    $tmpd_hour = $tmpd.Hour
                    $tmpd_min = $tmpd.Minute
                    if($tmpd_day -eq $tmp_time_day){
                        if($tmpd_hour -eq $tmp_time_hour){
                            if($tmp_time_min -eq $tmpd_min){
                                Write-Output 'file all time is OK'
                            }else{
                                Copy-Item -Path $path -Destination $path_backup -Force
                                $re_copy++
                            }
                        }else{
                            Copy-Item -Path $path -Destination $path_backup -Force
                            $re_copy++
                        }
                    }else{
                        Copy-Item -Path $path -Destination $path_backup -Force
                        $re_copy++
                    }

                }else{
                    Write-Output 'file bolowch d dr alga'
                    Copy-Item -Path $path -Destination $path_backup
                    $new_copy++
                }      
            }else{
                $path1 = $path_backup + '\' + $data1[$i]
                if([System.IO.Directory]::Exists($path1)){
                    $folder_size = "{0}" -f ((Get-ChildItem $path -Recurse | Measure-Object -Property Length -Sum -ErrorAction Stop).Sum / 1MB)
                    $folder_real_size = $folder_size -as [float]
                    Write-Output $folder_real_size
                    if($standart_folder_size -gt $folder_real_size){
                        Write-Output 'baga size tai file bna' 
                        Write-Output $path
                        Copy-Item -Path $path -Destination $path_backup -Force -Recurse
                    }else{
                        # энд байгаа фолдер доторхоо шалгах болно.---------------------------------------------
                        $tmp_path = $DesktopPath + '\' + $data1[$i]
                        $data2 = Get-ChildItem $tmp_path -Name
                        $data2_len = $data2.Count - 1
                        if($data2_len -eq 0){
                            $data2 = @($data2, 'white')
                        }
                        for($j=0; $j -le $data2_len; $j++){
                            Write-Output '-----------------------------hey'
                            $tmp_path_2 = $tmp_path + '\' + $data2[$j] # DESKTOP
                            $tmp_path_3 = $path_backup + '\' + $data1[$i] + '\' + $data2[$j] #BACKUP
                            if([System.IO.File]::Exists($tmp_path_2)){#дэлгцэндээрх файл байнуу гэдгийг шалгаж байна
                                Write-Output '2-file bna'
                                if([System.IO.File]::Exists($tmp_path_3)){#дэлгэцэндээрх файл Д-дээр байгаа үгүйг нь шалгаж байна
                                    Write-Output '2-D dr bna'
                                    $tmp_time = (Get-Item $tmp_path_2).LastWriteTime
                                    $tmp_time_day = $tmp_time.Day
                                    $tmp_time_hour = $tmp_time.Hour
                                    $tmp_time_min = $tmp_time.Minute
                                    $tmp_d_time = (Get-Item $tmp_path_3).LastWriteTime
                                    $tmp_d_Day = $tmp_d_Time.Day
                                    $tmp_d_hour = $tmp_d_Time.Hour
                                    $tmp_d_min = $tmp_d_Time.Minute
                                    if($tmp_time_day -eq $tmp_d_Day){
                                        if($tmp_time_hour -eq $tmp_d_hour){
                                            if($tmp_time_min -eq $tmp_d_min){
                                                Write-Output '2-all time is ok'
                                            }else{
                                                Copy-Item -Path $tmp_path_2 -Destination $tmp_path_3
                                                $re_copy++
                                            }
                                        }else{
                                            Copy-Item -Path $tmp_path_2 -Destination $tmp_path_3
                                            $re_copy++
                                        }
                                    }else{
                                        Copy-Item -Path $tmp_path_2 -Destination $tmp_path_3
                                        $re_copy++
                                    }

                                }else{
                                    Write-Output '2-D alga daxij xyylax'
                                    $temp_path = $path_backup+'\'+$data1[$i]
                                    Copy-Item -Path $tmp_path_2 -Destination $temp_path
                                    Write-Output 'Recopied'
                                    $new_copy++
                                }
                            }else{
                                Write-Output '2-folder bna'
                                #давхар фолдер доторхыг энд шалгах болно
                                if([System.IO.Directory]::Exists($tmp_path_3)){
                                    Write-Output $tmp_path_3
                                    #file size aa shalgana
                                    $folder_size = "{0}" -f ((Get-ChildItem $tmp_path_2 -Recurse | Measure-Object -Property Length -Sum -ErrorAction Stop).Sum / 1MB)
                                    $folder_real_size = $folder_size -as [float]  
                                    Write-Output $folder_real_size 
                                    if($standart_folder_size -gt $folder_real_size){
                                        #бага хэмжээтэй фолдер байгаа тул шууд хуулах 
                                        Write-Output '2-baga size'
                                        $temp_path = $path_backup + '\' + $data1[$i]
                                        copy-item -Path $tmp_path_2 -Destination $temp_path -Recurse -Force
                                    }else{
                                        Write-Output '2-ix size'
                                        #энд дээрх үйлдлүүдийг эхнээс нь дахин бичнэдээ
                                    }
                                }else{
                                    #baixgvi bol shyyd hyylna
                                    $temp_path = $path_backup + '\' + $data1[$i]
                                    copy-item -Path $tmp_path_2 -Destination $temp_path -Recurse
                                    $new_copy++
                                }
                            }
                        }
                    }
                }else{
                    Write-Output 'folder, d dr alga'
                    Copy-Item -Path $path -Destination $path_backup -Recurse
                    $new_copy++
                }
            }
        
    }

    $DesktopPath = '\\192.168.0.253\Install\7.FINANCE PROGRAM\6.0 final 20190808\sankhuu 6.0'
    $path_backup = 'D:\install\sankhuu 6.0'
    $data1 = Get-ChildItem $DesktopPath -name
    $data1_len = $data1.Count-1
    if($data1_len -eq 0){
        $data1 = @($data1, 'white')
    }
    for($i=0; $i -le $data1_len; $i++){
        $path = $DesktopPath + '\' + $data1[$i] 
            if([System.IO.File]::Exists($path)){
                Write-Output 'file bna'
                $path1 = $path_backup + '\' + $data1[$i]   
                if([System.IO.File]::Exists($path1)){
                    Write-Output 'd dr bna'  # энд он сараар шалгах процесс байна
                    $tmp_time = (Get-Item $path1).LastWriteTime
                    $tmp_time_day = $tmp_time.Day
                    $tmp_time_hour = $tmp_time.Hour
                    $tmp_time_min = $tmp_time.Minute
                    $tmpd = (Get-Item $path).LastWriteTime
                    $tmpd_day = $tmpd.Day
                    $tmpd_hour = $tmpd.Hour
                    $tmpd_min = $tmpd.Minute
                    if($tmpd_day -eq $tmp_time_day){
                        if($tmpd_hour -eq $tmp_time_hour){
                            if($tmp_time_min -eq $tmpd_min){
                                Write-Output 'file all time is OK'
                            }else{
                                Copy-Item -Path $path -Destination $path_backup -Force
                                $sa_recopy++
                            }
                        }else{
                            Copy-Item -Path $path -Destination $path_backup -Force
                            $sa_recopy++
                        }
                    }else{
                        Copy-Item -Path $path -Destination $path_backup -Force
                        $sa_recopy++
                    }

                }else{
                    Write-Output 'file bolowch d dr alga'
                    Copy-Item -Path $path -Destination $path_backup
                    $new_copy++
                }      
            }else{
                $path1 = $path_backup + '\' + $data1[$i]
                if([System.IO.Directory]::Exists($path1)){
                    $folder_size = "{0}" -f ((Get-ChildItem $path -Recurse | Measure-Object -Property Length -Sum -ErrorAction Stop).Sum / 1MB)
                    $folder_real_size = $folder_size -as [float]
                    Write-Output $folder_real_size
                    if($standart_folder_size -gt $folder_real_size){
                        Write-Output 'baga size tai file bna' 
                        Write-Output $path
                        Copy-Item -Path $path -Destination $path_backup -Force -Recurse
                    }else{
                        # энд байгаа фолдер доторхоо шалгах болно.---------------------------------------------
                        $tmp_path = $DesktopPath + '\' + $data1[$i]
                        $data2 = Get-ChildItem $tmp_path -Name
                        $data2_len = $data2.Count - 1
                        if($data2_len -eq 0){
                            $data2 = @($data2, 'white')
                        }
                        for($j=0; $j -le $data2_len; $j++){
                            Write-Output '-----------------------------hey'
                            $tmp_path_2 = $tmp_path + '\' + $data2[$j] # DESKTOP
                            $tmp_path_3 = $path_backup + '\' + $data1[$i] + '\' + $data2[$j] #BACKUP
                            if([System.IO.File]::Exists($tmp_path_2)){#дэлгцэндээрх файл байнуу гэдгийг шалгаж байна
                                Write-Output '2-file bna'
                                if([System.IO.File]::Exists($tmp_path_3)){#дэлгэцэндээрх файл Д-дээр байгаа үгүйг нь шалгаж байна
                                    Write-Output '2-D dr bna'
                                    $tmp_time = (Get-Item $tmp_path_2).LastWriteTime
                                    $tmp_time_day = $tmp_time.Day
                                    $tmp_time_hour = $tmp_time.Hour
                                    $tmp_time_min = $tmp_time.Minute
                                    $tmp_d_time = (Get-Item $tmp_path_3).LastWriteTime
                                    $tmp_d_Day = $tmp_d_Time.Day
                                    $tmp_d_hour = $tmp_d_Time.Hour
                                    $tmp_d_min = $tmp_d_Time.Minute
                                    if($tmp_time_day -eq $tmp_d_Day){
                                        if($tmp_time_hour -eq $tmp_d_hour){
                                            if($tmp_time_min -eq $tmp_d_min){
                                                Write-Output '2-all time is ok'
                                            }else{
                                                Copy-Item -Path $tmp_path_2 -Destination $tmp_path_3
                                                $sa_recopy++
                                            }
                                        }else{
                                            Copy-Item -Path $tmp_path_2 -Destination $tmp_path_3
                                            $sa_recopy++
                                        }
                                    }else{
                                        Copy-Item -Path $tmp_path_2 -Destination $tmp_path_3
                                        $sa_recopy++
                                    }

                                }else{
                                    Write-Output '2-D alga daxij xyylax'
                                    $temp_path = $path_backup+'\'+$data1[$i]
                                    Copy-Item -Path $tmp_path_2 -Destination $temp_path
                                    Write-Output 'Recopied'
                                    $sa_recopy++
                                }
                            }else{
                                Write-Output '2-folder bna'
                                #давхар фолдер доторхыг энд шалгах болно
                                if([System.IO.Directory]::Exists($tmp_path_3)){
                                    Write-Output $tmp_path_3
                                    #file size aa shalgana
                                    $folder_size = "{0}" -f ((Get-ChildItem $tmp_path_2 -Recurse | Measure-Object -Property Length -Sum -ErrorAction Stop).Sum / 1MB)
                                    $folder_real_size = $folder_size -as [float]  
                                    Write-Output $folder_real_size 
                                    if($standart_folder_size -gt $folder_real_size){
                                        #бага хэмжээтэй фолдер байгаа тул шууд хуулах 
                                        Write-Output '2-baga size'
                                        $temp_path = $path_backup + '\' + $data1[$i]
                                        copy-item -Path $tmp_path_2 -Destination $temp_path -Recurse -Force
                                    }else{
                                        Write-Output '2-ix size'
                                        #энд дээрх үйлдлүүдийг эхнээс нь дахин бичнэдээ
                                    }
                                }else{
                                    #baixgvi bol shyyd hyylna
                                    $temp_path = $path_backup + '\' + $data1[$i]
                                    copy-item -Path $tmp_path_2 -Destination $temp_path -Recurse
                                    $sa_recopy++
                                }
                            }
                        }
                    }
                }else{
                    Write-Output 'folder, d dr alga'
                    Copy-Item -Path $path -Destination $path_backup -Recurse
                    $new_copy++
                }
            }
        
    }
    
    Write-Output 'Loop ENDED'
    $end_time = Get-Date
    $ans_min = ($end_time-$start_time).Minutes
    $ans_ses = ($end_time-$start_time).Seconds
    $computer_name = $env:COMPUTERNAME
    if($ans_min -gt -1){
        $computer_name = $env:computername
        $txt_info = $ERP_folder + '\'+'Information' + '\'+$computer_name +' Processing Time '+ $ans_min+'min'+'-'+$ans_ses+'sec '+ 'recopy-'+$re_copy +' new copy -'+ $new_copy+ ' sankhuu recopy -' + $sa_recopy +' Developed by Miigaa_mind -----' +  '.txt'
        $start_time | Out-File -FilePath $txt_info
    }else{
        Write-Output 'pass'
    }
    Copy-Item $retail_shortcut_path -Destination $desko -Force
    Copy-Item $sankhuu_shortcut_path -Destination $desko -Force
    #------------------registry Adding--------------------
    New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' -Name '6.0retail' -Value 'D:\install\6checker.exe' -PropertyType "String"
    Pop-Location
    exit
    #next code here
	
}