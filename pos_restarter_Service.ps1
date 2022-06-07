#New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' -Name '6.0retail---' -Value 'D:\IBI\WILDFLY\posrestarter.bat' -PropertyType "String"


#------------------------ LOG DELETER ---------------------------------
$ecr = 'D:\IBI\WILDFLY\welcome-content\DBIS Files\POS\ECRTerminalLog'
$soc = 'D:\IBI\WILDFLY\welcome-content\DBIS Files\POS\SocialPayLog'
$log = 'D:\IBI\WILDFLY\standalone\log'
$saveday = 14;
'not equal -ne '
'-equal -eq '
'greater -qt '
'lower -lt '
'-------------------- ECR LOG delete -------------------------------'

$today_date = Get-Date

$ecr1 = Get-ChildItem $ecr -name # нэр нүүд байна
$ecr_len = $ecr1.Count-1 

for($i=0; $i -le $ecr_len; $i++){
    $path1 = $ecr + '\' + $ecr1[$i]
    $tempdate = (Get-Item $path1).CreationTime
    $ans = (NEW-TIMESPAN -Start $tempdate -End $today_date).TotalDays
    $ans = [math]::ceiling($ans) ;
    if($ans -gt $saveday){    # 10 
        Remove-Item -Path $path1    
    }
    #if($tempdate.Day -ne $today_date.Day -or $tempdate.Year -ne $today_date.Year -or $tempdate.Month -ne $today_date.Month){
        #   Remove-Item -Path $path 
    #}
}
'--------------------- Social Log delete ---------------------------'
$soc1 = Get-ChildItem $soc -name # нэр нүүд байна
$soc_len = $soc1.Count-1 

for($i=1; $i -le $soc_len; $i++){
    $path1 = $soc + '\' + $soc1[$i]
    $tempdate = (Get-Item $path1).CreationTime
    $ans = (NEW-TIMESPAN -Start $tempdate -End $today_date).TotalDays
    $ans = [math]::ceiling($ans);
    if($ans -gt $saveday){
        Remove-Item -Path $path1   
    }

}
'-------------------- SERVER LOG delete -------------------------------'
$log1 = Get-ChildItem $log -name # нэр нүүд байна
$log_len = $log1.Count-1 

for($i=1; $i -le $log_len; $i++){
    $path1 = $log + '\' + $log1[$i]
    $tempdate = (Get-Item $path1).CreationTime
    $ans = (NEW-TIMESPAN -Start $tempdate -End $today_date).TotalDays
    $ans = [math]::ceiling($ans);
    if($ans -gt $saveday){
        Remove-Item -Path $path1   
    }
}
#-------------- TEMP CLEAR --------------------------------------------------------
$a = $env:UserName
$b = 'C:\Users\' + $a + '\AppData\Local\Temp\*'
$c = 'C:\Users\' + $a + '\AppData\Local\Microsoft\Windows\Caches\*'
$d = 'C:\Users\' + $a + '\AppData\Local\Microsoft\Internet Explorer\*'
$f = 'C:\Users\' + $a + '\AppData\Local\Microsoft\Excel\*'
$e = 'C:\Users\' + $a + '\AppData\Local\Microsoft\OneDrive\*'
$g = 'C:\Users\' + $a + '\AppData\Local\Microsoft\Terminal Server Client\Cache\*'
$g1 = 'C:\Users\' + $a + '\AppData\Local\Microsoft\*'
$g2 = 'C:\Users\' + $a +' \AppData\Local\Microsoft\UserScanProfiles\*'
$g3 = 'C:\Users\' + $a +' \AppData\Local\OneDrive'
$g4 = 'C:\Users\' + $a +' \AppData\Local\Package Cache\*'
$g5 = 'C:\Users\' + $a +' \AppData\Local\Packages\*'
$g6 = 'C:\Users\' + $a +' \AppData\LocalLow\Intel\ShaderCache\*'
$g7 = 'C:\Users\' + $a +' \AppData\LocalLow\Microsoft\Internet Explorer\*'
#===============================================================================#
Remove-Item $b -Recurse -Force
Remove-Item $c -Recurse -Force
Remove-Item $d -Recurse -Force
Remove-Item $f -Recurse -Force
Remove-Item $e -Recurse -Force
Remove-Item $g -Recurse -Force
Remove-Item $g1 -Recurse -Force
Remove-Item $g2 -Recurse -Force
Remove-Item $g3 -Recurse -Force
Remove-Item $g4 -Recurse -Force
Remove-Item $g5 -Recurse -Force
Remove-Item $g6 -Recurse -Force
Remove-Item $g7 -Recurse -Force
#----------------------------- RESTART ZONE -----------------------------------

while(1 -eq 1){
    $current_date = Get-Date;
    if($current_date.Hour -eq 6 -and $current_date.Minute -eq 59){
        Write-Output "yes"
        Restart-Computer -Force
    }
    Start-Sleep -Seconds 30
	stop-service DoSvc
	stop-service wuauserv
}

