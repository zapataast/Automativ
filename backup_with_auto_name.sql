DECLARE @STR varchar(35) = 'Sansar421RetailPOS';
DECLARE @str2 varchar(100) = Concat('N',@STR,'-Full Database Backup');
DECLARE @FileName varchar(1000)
SELECT @FileName = (SELECT 'D:\IBI\WILDFLY\standalone\log\Backup_' + convert(varchar(500), GetDate(),112) + '.bak')
Backup Database @STR
To disk = @FileName with noformat,
noinit,
name = @str2,
SKIP,
NOREWIND,
NOUNLOAD,
STATS = 10
GO
