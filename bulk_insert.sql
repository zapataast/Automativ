USE Sansar171RetailPOS 
go
BULK INSERT dbo.ItemSalePrice
FROM 'C:\Users\User\Desktop\17v3.csv'
WITH (FIRSTROW = 2
,FIELDTERMINATOR = ',' 
, ROWTERMINATOR ='\n'
)

--file baigaa folderiin Properties > Security > Edit > Add > "NT Service\MSSQLSERVER" > Check Names > OK
											  --FUll control erx ogood OK > OK 
