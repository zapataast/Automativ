$locationPkid = @{c1=170327122911096938; c6=170406043146007079; c8=170324022223062632; 
         c13=170406043005843290; c15=210405095049125072; c16=200413064930688403;
         c17=210408023905809340;c21=170406043055546790; c22=180116104648397919;
        c25=210408043134292339;c26=171013040031087717;c32=170406042750095661;
        c34=170406042848021210;c38=200116052340975509;c39=170406042603125478;
        c40=181205124759015413;c42=190411023639162812;c61=210521091034372689;
        c61b=210617022521293295;c62=210325042508161356;c62b=210526113617344323}
#region тоxиргооны xэсгүүд -------------------------------------------------------------------------------
$current_date = Get-Date;
$SqlServer = "192.168.0.25" # SQL Server instance (HostName\InstanceName for named instance)
$Database = "msdb"      # SQL database to connect to 
$Ajtsi = "AltanJolooTradeSystemInfo";
$SqlAuthLogin = "sa"          # SQL Authentication login
$SqlAuthPass = "SpawnGG"     # SQL Authentication login password
$serverzam = "D:\itid\11. ServerPOS\log_deleter\"
$ipaddress = (Get-WmiObject -Class Win32_NetworkAdapterConfiguration | where { $_.DHCPEnabled -ne $null -and $_.DefaultIPGateway -ne $null }).IPAddress | Select-Object -First 1;
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< POS script PS file updatelog >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
$externallog = $serverzam + $ipaddress + ".txt"
$current_date.ToString() + " Script ajillaj exellee:" | out-file -FilePath $externallog -append
$pat1 = "D:\ITID\11. ServerPOS\pkid\"
#endregion 
#region Query zone <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
$querty_log_succ = "IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobhistory2 WHERE step_name = '192.168.0.236' and run_date=convert(varchar, getdate(), 112))
BEGIN
UPDATE msdb.dbo.sysjobhistory2
SET lvl1 = 1
WHERE step_name = '192.168.0.236' and run_date = convert(varchar, getdate(), 112)
END
ELSE
BEGIN
INSERT INTO msdb.dbo.sysjobhistory2 (step_name,lvl1,run_date)
VALUES ('192.168.0.236',1, convert(varchar, getdate(), 112) );
END"
$querty_log_fail = "IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobhistory2 WHERE step_name = '192.168.0.236' and run_date=convert(varchar, getdate(), 112))
    BEGIN
     UPDATE msdb.dbo.sysjobhistory2
     SET lvl1 = 0
     WHERE step_name = '192.168.0.236' and run_date = convert(varchar, getdate(), 112)
        END
            ELSE
            BEGIN
    INSERT INTO msdb.dbo.sysjobhistory2 (step_name,lvl1,run_date)
    VALUES ('192.168.0.236',0, convert(varchar, getdate(), 112) );
    END"
#endregion 
$sleeptime = 20;
$loop_status = 0;
$counter = 0;
$success_count = 0;

while(1 -eq 1){
    $current_date = Get-Date; 
    $tempminute = (New-Timespan -Hours $current_date.Hour -Minutes $current_date.Minute).TotalMinutes
    if($current_date.Hour -eq 0 -and $tempminute -gt 4 -and $loop_status -eq 0){
        if(Test-Connection -IPAddress $SqlServer -Quiet){
            #ITEMSALEPRCICE >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
            #5 aas xoiш 5 minuted vvsj baigaa
            foreach ($i in $locationPkid.GetEnumerator()) {
                Write-Output $($i.Value)
                #region Query_to_csv---------------------------------------------------------------------------------------------------------
                $Query_to_csv = "SELECT main.PkId, main.Type, main.BeginDate, main.ItemPkId, main.BarcodePkId,
                main.LocationPkId, main.SalePrice, main.BalanceString, 1 as Status,
                0 as HealthPrice, 0 as HealthDiscountPrice,
                0 as PackagePkId,0 as PackageBarCodePkId,'null_null' PackageBalanceString,
                '' as NextSalePrice,'' as NextBeginDate,0 as IsEndPrice,main.ContractMapPkId
                 FROM [AltanJolooTradeSystemInfo].[dbo].[itemsalepricenew1] as main
                where locationpkid = '"+$($i.Value)+ "'";
                #endregion
                #region SQL query zone----------------------------------------------------------------------------------------------------
                $connString = "Data Source=$SqlServer;Database=$Ajtsi;User ID=$SqlAuthLogin;Password=$SqlAuthPass"
                $conn = New-Object System.Data.SqlClient.SqlConnection $connString
                $conn.Open()
                $sqlcmd = $conn.CreateCommand()
                $sqlcmd = New-Object System.Data.SqlClient.SqlCommand
                $sqlcmd.Connection = $conn
                $sqlcmd.CommandText = $Query_to_csv
                $adp = New-Object System.Data.SqlClient.SqlDataAdapter $sqlcmd
                $data = New-Object System.Data.DataSet
                #endregion 
                try {
                $adp.Fill($data) | Out-Null 
                $var = $pat1+$($i.Value) + '.csv'
                $data.Tables[0] | ConvertTo-Csv -delimiter "," -NoTypeInformation | %{$_ -replace '"',''} > $var
                $success_count = $success_count + 1;
                    Write-Output $success_count
                }
                catch {Write-Output 'failed'}
                
                #$data.Tables | Format-Table
                $conn.Close();
            }    
            Write-Output "exnii step duuslaa"
            (Get-Date).ToString() + " ItemPriceTable_to_csv zone done." | out-file -FilePath $externallog -append
            #ItemSaleWholePrice >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
            #2 minuted created
            foreach ($i in $locationPkid.GetEnumerator()) {
                Write-Output $($i.Value)
                #region QUERY querywhole
                $querywhole = "SELECT 
                main.PkId ,null as OrganizationPkId,
                main.Type ,main.BeginDate ,
                main.ItemPkId, main.BarcodePkId, 
                main.LocationPkId ,main.PriceType ,
                main.Quantity ,main.SalePrice ,
                main.BalanceString,
                1 as Status, 0 as IsEndPrice, main.ContractMapPkId
                from [AltanJolooTradeSystemInfo].[dbo].[itemsalewholeprice1] as main
                where main.locationpkid =   '" +$($i.Value) + "'"
                #endregion
                    $connString = "Data Source=$SqlServer;Database=$Ajtsi;User ID=$SqlAuthLogin;Password=$SqlAuthPass"
                    $conn = New-Object System.Data.SqlClient.SqlConnection $connString
                    $conn.Open()
                    $sqlcmd = $conn.CreateCommand()
                    $sqlcmd = New-Object System.Data.SqlClient.SqlCommand
                    $sqlcmd.Connection = $conn
                    $sqlcmd.CommandText = $querywhole
                    $adp = New-Object System.Data.SqlClient.SqlDataAdapter $sqlcmd
                    $data = New-Object System.Data.DataSet
                    try {
                        $adp.Fill($data) | Out-Null 
                        $var = $pat1+$($i.Value) + 'B.csv'
                        $data.Tables[0] | ConvertTo-Csv -delimiter "," -NoTypeInformation | %{$_ -replace '"',''} > $var
                        $success_count = $success_count + 1;
                        Write-Output $success_count
                    }catch {Write-Output 'failed'}
                    
                    $conn.Close();
                    $counter=$counter+1;  
                    if($counter -eq $locationPkid.Count -and $success_count/2 -eq $locationPkid.Count){
                        Write-Output "loop stopped"
                            $loop_status = 1; # onoodoriin LOOPiig zogsooow
                            #region log bicij vldej bna--------------------------------------------------------------------------
                            $connString = "Data Source=$SqlServer;Database=$Database;User ID=$SqlAuthLogin;Password=$SqlAuthPass"
                            $conn = New-Object System.Data.SqlClient.SqlConnection $connString
                            $conn.Open()
                            $sqlcmd = $conn.CreateCommand()
                            $sqlcmd = New-Object System.Data.SqlClient.SqlCommand
                            $sqlcmd.Connection = $conn
                            $sqlcmd.CommandText = $querty_log_succ
                            $adp = New-Object System.Data.SqlClient.SqlDataAdapter $sqlcmd
                            $data = New-Object System.Data.DataSet
                            $adp.Fill($data) | Out-Null 
                            $conn.close();
                            $success_count = 0;
                            $counter = 0;
                            #endregion 
                            (Get-Date).ToString() + " Onoodriin loop zogsow" | out-file -FilePath $externallog -append

                    }elseif($counter -eq $locationPkid.Count){
                            #region query failed log vldeej bna --------------------------------------------------------------------
                            $connString = "Data Source=$SqlServer;Database=$Database;User ID=$SqlAuthLogin;Password=$SqlAuthPass"
                            $conn = New-Object System.Data.SqlClient.SqlConnection $connString
                            $conn.Open()
                            $sqlcmd = $conn.CreateCommand()
                            $sqlcmd = New-Object System.Data.SqlClient.SqlCommand
                            $sqlcmd.Connection = $conn
                            $sqlcmd.CommandText = $querty_log_fail
                            $adp = New-Object System.Data.SqlClient.SqlDataAdapter $sqlcmd
                            $data = New-Object System.Data.DataSet
                            $adp.Fill($data) | Out-Null 
                            $conn.close();
                            #endregion
                            (Get-Date).ToString() + " Error vvsej daxin loop ajillax gej bna" | out-file -FilePath $externallog -append
                            $success_count = 0;
                            $counter = 0;
                    }    
            }
            #for loop end <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 
        }
        
    }
    #loop_status iig sergeej deed taliin looopiig ajilluulax 
    if($current_date.Hour -eq 0 -and $current_date.Minute -eq 0){
        $loop_status = 0;
        (Get-Date).ToString() + " Loop Status daxin 1 bollooo." | out-file -FilePath $externallog -append
    } 
    #pkid file-уудыг устгаж байна
    if($current_date.Hour -gt 13 -and $loop_status -eq 1){
        Remove-Item -Path 'D:\ITID\11. ServerPOS\pkid\*'
        (Get-Date).ToString() + " pkid csv file-yydiig ustgaj bna." | out-file -FilePath $externallog -append
    }
    Start-Sleep -Seconds $sleeptime
}
