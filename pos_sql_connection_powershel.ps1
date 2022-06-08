Import-Module sqlps 
#netsh firewall set portopening protocol = TCP port = 1433 name = SQLPort mode = ENABLE scope = SUBNET profile = CURRENT
#netsh advfirewall firewall add rule name = SQLPort dir = in protocol = tcp action = allow localport = 1433 remoteip = localsubnet profile = DOMAIN
$com_name = HOSTNAME.EXE #computername getting...
invoke-sqlcmd -query    "SELECT TOP 12 *    
                        FROM [Sansar171RetailPOS].[dbo].[Item]" -ServerInstance $com_name | format-table

#---------------------------------------------------------------------------#
    $SqlServer    = "192.168.0.25" # SQL Server instance (HostName\InstanceName for named instance)
    $Database     = "msdb"      # SQL database to connect to 
    $SqlAuthLogin = "sa"          # SQL Authentication login
    $SqlAuthPass  = "SpawnGG"     # SQL Authentication login password
    
    $dargiin_odor = 1;
    $ipaddress = Get-NetIPAddress -AddressFamily IPv4 -InterfaceIndex $(Get-NetConnectionProfile | Select-Object -ExpandProperty InterfaceIndex) | Select-Object -ExpandProperty IPAddress
    $Query = "SELECT *
    FROM [msdb].[dbo].[sysjobhistory] 
    WHERE step_name = '10.34.1.6'
    and convert(varchar, getdate(), 112) = run_date" #convert(varchar, getdate(), 112)
    
                        
$connString = "Data Source=$SqlServer;Database=$Database;User ID=$SqlAuthLogin;Password=$SqlAuthPass"
#Create a SQL connection object
$conn = New-Object System.Data.SqlClient.SqlConnection $connString
$conn.Open()

if($current_date.Hour -lt 7){
    Write-Output 'Noxtsol biyelej bna'
}else{
    Write-Output 'Bielexgvi bna'
}
        $sqlcmd = $conn.CreateCommand()
        $sqlcmd = New-Object System.Data.SqlClient.SqlCommand
        $sqlcmd.Connection = $conn
        $sqlcmd.CommandText = $query
        $adp = New-Object System.Data.SqlClient.SqlDataAdapter $sqlcmd
        $data = New-Object System.Data.DataSet
        $adp.Fill($data) | Out-Null
        $data.Tables | format-table
        $conn.Close()


if($data.Tables.run_status -eq $null){
    Write-Output "null bna"
}else{
    Write-Output "Утга байна"
    if($data.Tables.run_status -eq 1){
        Stop-Computer -Force
    }
}
$current_date = Get-Date;