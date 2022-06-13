#New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' -Name '6.0retail---' -Value 'D:\IBI\WILDFLY\posrestarter.bat' -PropertyType "String"

#------------------------ LOG DELETER -----------------------------------------
$ecr = 'D:\IBI\WILDFLY\welcome-content\DBIS Files\POS\ECRTerminalLog'
$soc = 'D:\IBI\WILDFLY\welcome-content\DBIS Files\POS\SocialPayLog'
$log = 'D:\IBI\WILDFLY\standalone\log'
$saveday = 21;
'not equal -ne '
'-equal -eq    '
'greater -qt   '
'lower -lt     '
$SqlServer    = "192.168.0.25" # SQL Server instance (HostName\InstanceName for named instance)
$Database     = "msdb"      # SQL database to connect to 
$DatabasePos  = "Sansar171RetailPOS"   
$ComputerN    =  HOSTNAME.EXE;  
$SqlAuthLogin = "sa"          # SQL Authentication login
$SqlAuthPass  = "SpawnGG"     # SQL Authentication login password
$logoutputpath = "D:\IBI\WILDFLy\querytest.xml" ; $logoutputpath1 = "D:\IBI\WILDFLy\deleting_log.txt" ;$logoutputpath2 = "D:\IBI\WILDFLy\shrink.txt"
$dargiin_check = "D:\IBI\WILDFLY\standalone\log\Backup_" + $current_date.ToString("yyyyMMdd") + ".bak";
$ipaddress = Get-NetIPAddress -AddressFamily IPv4 -InterfaceIndex $(Get-NetConnectionProfile | Select-Object -ExpandProperty InterfaceIndex) | Select-Object -ExpandProperty IPAddress
#-------------------------Сарын сүүлийн 1 дэxь өдөрийг олоx 
$current_date = Get-Date;
$last_day = [DateTime]::DaysInMonth($current_date.Year, $current_date.Month)
$last_day_date = $current_date.AddDays($last_day-$current_date.Day)
for ($i = 1; $i -lt 8; $i++) {
    Write-Output $last_day_date.DayOfWeek;

    if($last_day_date.DayOfWeek -eq 'Monday'){
        $dargiin_odor = $last_day_date.Day;
        break;
    }
    $last_day_date = $last_day_date.AddDays(-1);
}
Write-Output $dargiin_odor;
$dargiin_odor = 14
#===------------------- ECR LOG delete -----------------------------------------

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
#--------------------- Social Log delete ----------------------------------------
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
#-------------------- SERVER LOG delete ------------------------------------------
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
#=================================================================================#
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
#----------------------------- RESTART ZONE ---------------------------------------#
$Query_pos_backup = "DECLARE @STR varchar(35) = '" + $DatabasePos + "';
DECLARE @str2 varchar(100) = Concat('N',@STR,'-Full Database Backup');
DECLARE @FileName varchar(1000)
SELECT @FileName = (SELECT 'D:\IBI\WILDFLY\standalone\log\Backup_' + convert(varchar(500), GetDate(),112) + '.bak')
Backup Database @STR To disk = @FileName with noformat, noinit, name = @str2, SKIP, NOREWIND, NOUNLOAD, STATS = 10";
$Query = "SELECT run_status
FROM [msdb].[dbo].[sysjobhistory] 
WHERE step_name = '"+ $ipaddress + "'
and convert(varchar, getdate(), 112) = run_date" #convert(varchar, getdate(), 112)
$Query_shrink_db = "USE ["+ $DatabasePos + "]
DBCC SHRINKDATABASE(N'" + $DatabasePos + "' )
USE [" + $DatabasePos + "] 
DBCC SHRINKFILE (N'" + $DatabasePos + "_Data' , 255)"
$deleting_day = $current_date.AddDays(-$current_date.Day);
$deleting_day = $deleting_day.ToString("yyyyMMdd")
$Query_pos_delete = "DELETE FROM " + $DatabasePos + ".dbo.BillDtl WHERE BillDate <= '" + $deleting_day + "';
                     DELETE FROM " + $DatabasePos + ".dbo.Billhdr WHERE BillDate <= '" + $deleting_day + "';
                     DELETE FROM " + $DatabasePos + ".dbo.logbillaction WHERE CreatedDate <= '" + $deleting_day + "';
                     DELETE FROM " + $DatabasePos + ".dbo.logvatps WHERE CreatedDate <= '" + $deleting_day + "';
                     DELETE FROM " + $DatabasePos + ".dbo.logvatpsarchive WHERE CreatedDate <= '" + $deleting_day + "';"; 
while(1 -eq 1){
    $current_date = Get-Date;
    #if($current_date.Hour -eq 6 -and $current_date.Minute -eq 59){
        #Write-Output "yes"
        #Stop-Computer -Force
        #Restart-Computer -Force}
    if($current_date.Hour -lt 7){
        Write-Output 'Noxtsol biyelej bna'
        $connString = "Data Source=$SqlServer;Database=$Database;User ID=$SqlAuthLogin;Password=$SqlAuthPass"
        #Create a SQL connection object
        $conn = New-Object System.Data.SqlClient.SqlConnection $connString
        $conn.Open()
        
        $sqlcmd = $conn.CreateCommand()
        $sqlcmd = New-Object System.Data.SqlClient.SqlCommand
        $sqlcmd.Connection = $conn
        $sqlcmd.CommandText = $query
        $adp = New-Object System.Data.SqlClient.SqlDataAdapter $sqlcmd 
        $data = New-Object System.Data.DataSet
        $adp.Fill($data) | Out-Null
        $data.Tables | format-table | Out-File -filePath $logoutputpath 
        $conn.Close()
        if($data.Tables.run_status -eq $null){
            Write-Output "null bna"
        }else{
            Write-Output "Утга байна"
            if($data.Tables.run_status -eq 1){
                Stop-Computer -Force
            }
        }
    }  
    $bool1 = Test-Path -Path $dargiin_check -PathType Leaf #BACKUP awsan vgvig шалгаж байна
    if($dargiin_odor -eq $current_date.Day -and $bool1 -eq 0){ #backup авсан үгүй болон даргын өдөр зэрэг таарч байгаа үгүйг шалгаж байна. 
        #----------------------BACKUP ZONE -------------------------------------------------------------------------------- 
        $connString = "Data Source=$ComputerN;Database=$DatabasePos;User ID=$SqlAuthLogin;Password=$SqlAuthPass"
        $conn = New-Object System.Data.SqlClient.SqlConnection $connString
        $conn.Open()
        $sqlcmd = $conn.CreateCommand()
        $sqlcmd = New-Object System.Data.SqlClient.SqlCommand
        $sqlcmd.Connection = $conn
        $sqlcmd.CommandText = $Query_pos_backup
        $adp = New-Object System.Data.SqlClient.SqlDataAdapter $sqlcmd
        $data = New-Object System.Data.DataSet
        $adp.Fill($data) | Out-Null
        $data.Tables | format-table
        Start-Sleep -Seconds 10
        #------------------- DELETING ZONE ---------------------------------------------------------------------------
        $sqlcmd = $conn.CreateCommand()
        $sqlcmd = New-Object System.Data.SqlClient.SqlCommand
        $sqlcmd.Connection = $conn
        $sqlcmd.CommandText = $Query_pos_delete
        $adp = New-Object System.Data.SqlClient.SqlDataAdapter $sqlcmd
        $data = New-Object System.Data.DataSet
        $adp.Fill($data) | Out-Null
        $data.Tables | format-table | Out-File -filePath $logoutputpath1 
        Start-Sleep -Seconds 10
        #------------------- SHRINKE FILE ZONE ---------------------------------------------------------------------
        $sqlcmd = $conn.CreateCommand()
        $sqlcmd = New-Object System.Data.SqlClient.SqlCommand
        $sqlcmd.Connection = $conn
        $sqlcmd.CommandText = $Query_shrink_db
        $adp = New-Object System.Data.SqlClient.SqlDataAdapter $sqlcmd
        $data = New-Object System.Data.DataSet
        $adp.Fill($data) | Out-Null
        $data.Tables | format-table | Out-File -filePath $logoutputpath2 
        Start-Sleep -Seconds 10
        $conn.Close()    
    }
    Start-Sleep -Seconds 75
	stop-service DoSvc
	stop-service wuauserv
}

