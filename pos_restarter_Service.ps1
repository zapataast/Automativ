#New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' -Name '6.0retailv2---' -Value 'D:\Scripts\posrestarter.bat' -PropertyType "String"
#------------------------ LOG DELETER -----------------------------------------
$ecr = 'D:\IBI\WILDFLY\welcome-content\DBIS Files\POS\ECRTerminalLog'
$soc = 'D:\IBI\WILDFLY\welcome-content\DBIS Files\POS\SocialPayLog'
$log = 'D:\IBI\WILDFLY\standalone\log'
$databaselist = "10.1.1.5 Sansar1RetailPOS
10.32.1.5 Sansar32RetailPOS
10.34.1.5 Sansar34RetailPOS
10.13.1.5 Sansar13RetailPOS
10.21.1.5 Sansar21RetailPOS
10.6.1.5 Sansar6RetailPOS 
10.1.30.5 Sansar9RetailPOS
10.8.1.5 Sansar8RetailPOS 
10.39.1.5 Sansar39RetailPOS
10.34.1.6 Sansar341RetailPOS 
10.26.1.5 Sansar26RetailPOS 
10.26.1.6 OlimpRetailPOS 
10.6.1.6 Sansar61RetailPOS
10.32.1.6 Sansar321RetailPOS 
10.1.1.6 Sansar11RetailPOS 
10.8.1.6 Sansar81RetailPOS
10.13.1.6 Sansar132RetailPOS 
10.22.1.6 Sansar22RetailPOS 
10.22.1.5 Sansar221RetailPOS 
10.21.1.6 Sansar211RetailPOS 
10.39.1.3 Nemelt39RetailPOS 
10.40.1.6 Sansar401RetailPOS 
10.40.1.5 Sansar40RetailPOS 
10.12.1.5 Sansar42RetailPOS	
10.90.1.5 ShangrilaRetailPOS 
10.21.1.7 Sansar212RetailPOS 
10.38.1.5 Sansar38RetailPOS 
10.1.1.15 EshopRetailPOS
10.40.1.7 Sansar402RetailPOS 
10.38.1.7 Sansar381RetailPOS 
10.16.1.6 Sansar161RetailPOS 
10.16.1.5 Sansar16RetailPOS 
10.34.1.7 Sansar342RetailPOS 
10.39.1.13 Sansar392RetailPOS 
10.12.1.7 Sansar421RetailPOS 
10.15.1.5 Sansar15RetailPOS 
10.15.1.6 Sansar151RetailPOS 
10.25.1.5 Sansar25RetailPOS 
10.25.1.6 Sansar251RetailPOS 
10.62.1.7 Sansar62RetailPOS 
10.62.1.6 Sansar621RetailPOS 
10.62.1.5 Sansar622RetailPOS 
10.22.1.30 Sansar222RetailPOS
10.61.1.6 Sansar61RetailPOS
10.61.1.5 Sansar612RetailPOS 
10.61.1.7 Sansar613RetailPOS 
10.22.1.31 Sansar223RetailPOS 
10.17.1.5 Sansar171RetailPOS 
10.17.1.6 Sansar172RetailPOS 
"
$poslist= $databaselist -split "\n"
 #'not equal -ne !=''-equal -eq  ==''greater -qt  >''lower -lt <     '
$current_date = Get-Date;
$SqlServer    = "192.168.0.25" # SQL Server instance (HostName\InstanceName for named instance)
$Database     = "msdb"      # SQL database to connect to 
$ComputerN    =  HOSTNAME.EXE;  
$SqlAuthLogin = "sa"          # SQL Authentication login
$SqlAuthPass  = "SpawnGG"     # SQL Authentication login password
$serverzam = "\\it.ajnets.com\itid\11. ServerPOS\log_deleter\"
$posuntraxif = 0; # 1 цагаас унтарна
$default_printer = Get-WMIObject -Query " SELECT * FROM Win32_Printer WHERE Default=$true"
$printername = $default_printer.name
$printerjobs = Get-PrintJob -PrinterName $printername
$logoutputpath = "D:\Scripts\Backup\querytest.xml" ; $logoutputpath1 = "D:\Scripts\Backup\deleting_log.txt" ;$logoutputpath2 = "D:\Scripts\Backup\shrink.txt"
$dargiin_check = "D:\IBI\WILDFLY\standalone\log\Backup_" + $current_date.ToString("yyyyMMdd") + ".bak";
#$ipaddress = Get-NetIPAddress -AddressFamily IPv4 -InterfaceIndex $(Get-NetConnectionProfile | Select-Object -ExpandProperty InterfaceIndex) | Select-Object -ExpandProperty IPAddress
$ipaddress=(Get-WmiObject -Class Win32_NetworkAdapterConfiguration | where {$_.DHCPEnabled -ne $null -and $_.DefaultIPGateway -ne $null}).IPAddress | Select-Object -First 1;
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< POS script PS file updatelog >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
$ps_script_udpate = (Get-Item "D:\Scripts\pos_restarter_Service.ps1").LastWriteTime
$temp1 = $serverzam + "POS_log_IP_" + $ipaddress + "_DATE_"+$ps_script_udpate.Month +"_"+ $ps_script_udpate.Day +"_" +$ps_script_udpate.Hour+ "_"+$ps_script_udpate.Minute +".txt";
Add-Content -Path $temp1 -Value 'End of file' # last ps1 file xyylagdaj baigaa vgvig txt eer 0.236 ryy medeelellj bna
#########################################################################################################
for($i= 0 ; $i -lt $poslist.Length-1; $i++){
    $temp=$poslist[$i].Split(" ")
    if($ipaddress -eq $temp[0]){
        $DatabasePos = $temp[1]  # databaselist-c posiin neriig salgaj awc bna
        break;
    }
}
#-------------------------Сарын сүүлийн 1 дэxь өдөрийг олоx 
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
$deleting_day = $current_date.AddDays(-$current_date.Day);
$deleting_day = $deleting_day.ToString("yyyyMMdd")
$saveday = $dargiin_odor
#===------------------- ECR LOG delete -----------------------------------------

$today_date = Get-Date
if($dargiin_odor -eq $current_date.Day){
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
}
}

#--------------------- Social Log delete ----------------------------------------
if($dargiin_odor -eq $current_date.Day){
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
}

#-------------------- SERVER LOG delete ------------------------------------------
if($dargiin_odor -eq $current_date.Day){
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
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< QUERy ZONE >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
$Query_pos_backup = "DECLARE @STR varchar(35) = '" + $DatabasePos + "';
DECLARE @str2 varchar(100) = Concat('N',@STR,'-Full Database Backup');
DECLARE @FileName varchar(1000)
SELECT @FileName = (SELECT 'D:\IBI\WILDFLY\standalone\log\Backup_' + convert(varchar(500), GetDate(),112) + '.bak')
Backup Database @STR To disk = @FileName with noformat, noinit, name = @str2, SKIP, NOREWIND, NOUNLOAD, STATS = 10";
$Query = "SELECT run_status,run_date
FROM [msdb].[dbo].[sysjobhistory] 
WHERE step_name = '"+ $ipaddress + "'
and convert(varchar, getdate(), 112) = run_date" #convert(varchar, getdate(), 112)
$Query_shrink_db = "USE ["+ $DatabasePos + "]
DBCC SHRINKDATABASE(N'" + $DatabasePos + "' )
USE [" + $DatabasePos + "] 
DBCC SHRINKFILE (N'" + $DatabasePos + "_Data' , 255)"

$Query_pos_delete = "DELETE FROM " + $DatabasePos + ".dbo.BillDtl WHERE BillDate <= '" + $deleting_day + "';
                     DELETE FROM " + $DatabasePos + ".dbo.Billhdr WHERE BillDate <= '" + $deleting_day + "';
                     DELETE FROM " + $DatabasePos + ".dbo.logbillaction WHERE CreatedDate <= '" + $deleting_day + "';
                     DELETE FROM " + $DatabasePos + ".dbo.logvatps WHERE CreatedDate <= '" + $deleting_day + "';
                     DELETE FROM " + $DatabasePos + ".dbo.logvatpsarchive WHERE CreatedDate <= '" + $deleting_day + "';"; 
$sleeptime = 3;
$backup_delete_status = 0
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< RESTART ZONE >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
while(1 -eq 1){
    $current_date = Get-Date;
    if($current_date.Hour -eq 5 -and $current_date.Minute -eq 45){
        Write-Output "yes"
        Stop-Computer -Force
    }
    #LOCAL SQL query WORKING ZONE >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    $bool1 = Test-Path -Path $dargiin_check -PathType Leaf #BACKUP awsan vgvig шалгаж байна
    if($dargiin_odor -eq $current_date.Day -and $current_date.Hour -eq 0 -and $backup_delete_status -eq 0){ #backup авсан үгүй болон даргын өдөр зэрэг таарч байгаа үгүйг шалгаж байна. 
        #----------------------BACKUP ZONE -------------------------------------------------------------------------------- 
        $connString = "Data Source=$ComputerN;Database=$DatabasePos;User ID=$SqlAuthLogin;Password=$SqlAuthPass"
        $conn = New-Object System.Data.SqlClient.SqlConnection $connString
        $conn.Open()
        #$sqlcmd = $conn.CreateCommand()
        #$sqlcmd = New-Object System.Data.SqlClient.SqlCommand
        #$sqlcmd.Connection = $conn
        #$sqlcmd.CommandText = $Query_pos_backup
        #$adp = New-Object System.Data.SqlClient.SqlDataAdapter $sqlcmd
        #$data = New-Object System.Data.DataSet
        #$adp.Fill($data) | Out-Null
        #$data.Tables | format-table
        #Start-Sleep -Seconds 10
        #------------------- DELETING ZONE ---------------------------------------------------------------------------
        $sqlcmd = $conn.CreateCommand()
        $sqlcmd = New-Object System.Data.SqlClient.SqlCommand
        $sqlcmd.Connection = $conn
        $sqlcmd.CommandText = $Query_pos_delete
        $adp = New-Object System.Data.SqlClient.SqlDataAdapter $sqlcmd
        $data = New-Object System.Data.DataSet
        $adp.Fill($data) | Out-Null
        $data.Tables | format-table | Out-File -filePath $logoutputpath1 
        Start-Sleep -Seconds 1
        #------------------- SHRINKE FILE ZONE ---------------------------------------------------------------------
        $sqlcmd = $conn.CreateCommand()
        $sqlcmd = New-Object System.Data.SqlClient.SqlCommand
        $sqlcmd.Connection = $conn
        $sqlcmd.CommandText = $Query_shrink_db
        $adp = New-Object System.Data.SqlClient.SqlDataAdapter $sqlcmd
        $data = New-Object System.Data.DataSet
        $adp.Fill($data) | Out-Null
        $data.Tables | format-table | Out-File -filePath $logoutputpath2 
        Start-Sleep -Seconds 1
        $conn.Close()    
		backup_delete_status = 1
    }
    # PRINTER QUEUE RESTART ZONE >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    $printerjobs = Get-PrintJob -PrinterName $printername
    if($printerjobs.Length -gt 3){
        Write-Output 'bna'
        Restart-PrintJob -PrinterName $printername -ID 3
        Restart-PrintJob -PrinterName $printername -ID 1
        Restart-PrintJob -PrinterName $printername -ID 2
        Restart-PrintJob -PrinterName $printername -ID 4
    }
    # POS SHUTDOWN ZONE #############################################################################################################
    if($current_date.Hour -lt 6){
        $sleeptime = 58;
		$current_date = Get-Date; #цаг 00 руу шилжихэд сервер компьютерүүд зөрүү үүсж магадгүй тул. 
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
			$tempday = (get-date).ToString("yyyyMMdd");
            Write-Output "Утга байна"
            if($data.Tables.run_status -eq 1 -and $tempday -eq $data.Tables.run_date -and $current_date.Hour -gt $posuntraxif){
                #Тухайн салбарын ажилчид 12 цагаас хойш кассаа хаах тохиолдол байдаг тул 1 цагаас эхлэн унтарч эхлэнэ
                $outfilename = $serverzam + "POS_Down_" + $ipaddress + "_DATE_" + $current_date.Hour +"_" +$current_date.Minute+".txt";
                Add-Content -Path $outfilename -Value 'End of file'
                Stop-Computer -Force
            }
        }
    }else{
        $sleeptime = 4;
    }
    # ALWAySUP RESTARTER ZONE ##########################################################################################################
    $deployment = 'D:\IBI\WILDFLY\standalone\deployments'
    $dep_files = Get-ChildItem $deployment -Name
    for ($i = 0; $i -lt $dep_files.Count; $i++) {
        $def_extension = (Split-Path -Path $dep_files[$i] -Leaf).Split(".")[2];
        if($def_extension -eq "undeployed"){
            $tmp = $deployment + "\" + $dep_files[$i-1]
            Remove-Item -Path $tmp -Force
        }
    }
    Start-Sleep -Seconds $sleeptime
	stop-service DoSvc
	stop-service wuauserv
}

