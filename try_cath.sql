DECLARE @Run_status INT  
                     DECLARE @date1 datetime
                     DECLARE @ip varchar(16)
                     SET @ip = '"+$ipaddress+"'
                     BEGIN TRY
                         SET @date1 = getdate();
                         --- Qeury >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>..
                         DELETE FROM ["+$ipaddress+"].["+$DatabasePos+"].[dbo].[ItemSalePrice]
                         INSERT INTO ["+$ipaddress+"].["+$DatabasePos+"].[dbo].[ItemSalePrice] 
                         SELECT
                         main.PkId ,
                         main.Type ,
                         main.BeginDate ,
                         main.ItemPkId, main.BarcodePkId, 
                         main.LocationPkId ,
                         main.SalePrice ,
                         main.BalanceString,
                         1 as Status, 0 as HealthPrice, 0 as HealthDiscountPrice, 0 as PackagePkId,0 as PackageBarCodePkId, 'null_null' as  PackageBalanceString, NULL as NextSalePrice, NULL as NextBeginDate, 0 as IsEndPrice, main.ContractMapPkId
                         FROM [AltanJolooTradeSystemInfo].[dbo].[itemsalepricenew1] as main
                         WHERE main.locationpkid = '"+$locationpkId+"'	
                         DELETE FROM ["+$ipaddress+"].["+$DatabasePos+"].[dbo].[ItemSaleWholePrice] 
                         INSERT INTO ["+$ipaddress+"].["+$DatabasePos+"].[dbo].[ItemSaleWholePrice] 
                         SELECT
                         main.PkId ,
                         null as OrganizationPkId,
                         main.Type ,
                         main.BeginDate ,
                         main.ItemPkId, 
                         main.BarcodePkId, 
                         main.LocationPkId ,
                         main.PriceType ,
                         main.Quantity ,
                         main.SalePrice ,
                         main.BalanceString,
                         1 as Status, 0 as IsEndPrice, main.ContractMapPkId
                         FROM [AltanJolooTradeSystemInfo].[dbo].[itemsalewholeprice1] as main
                         WHERE main.locationpkid = '"+ $locationpkId + "'
                         ----<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                         SET @Run_status = 1;
                          IF EXISTS (SELECT 1 FROM [msdb].[dbo].[sysjobhistory2] WHERE run_date = convert(varchar, getdate(), 112) and step_name = @ip)
                             BEGIN
                                 UPDATE [msdb].[dbo].[sysjobhistory2]
                                 SET run_status = @Run_status , run_duration = Datediff(MINUTE, @date1, GETDATE())
                                 WHERE run_date = convert(varchar, getdate(), 112) and step_name = @ip ;
                             END
                          ELSE
                             BEGIN
                             INSERT INTO [msdb].[dbo].[sysjobhistory2]  (step_name, run_status, run_date,run_time, run_duration)
                             VALUES (@ip, @Run_status, CONVERT(varchar, getdate(), 112) , CONVERT(varchar,@date1,108), Datediff(MINUTE, @date1, GETDATE()));
                             END
                     END TRY  
                     BEGIN CATCH
                         SET @Run_status =0;
                             IF EXISTS (SELECT 1 FROM [msdb].[dbo].[sysjobhistory2] WHERE run_date = convert(varchar, getdate(), 112) and step_name = @ip)
                             BEGIN
                                 UPDATE [msdb].[dbo].[sysjobhistory2]
                                 SET run_status = @Run_status
                                 WHERE run_date = convert(varchar, getdate(), 112) and step_name = @ip ;
                             END
                             ELSE
                             BEGIN
                                 INSERT INTO [msdb].[dbo].[sysjobhistory2]  (step_name, run_status, run_date,run_time, run_duration)
                                 VALUES (@ip, @Run_status, convert(varchar, getdate(), 112) , CONVERT(varchar,getdate(),108),0 );
                             END 
                     END CATCH;                    
