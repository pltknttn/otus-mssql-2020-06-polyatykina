/*
Insert, Update, Merge
1. Довставлять в базу 5 записей используя insert в таблицу Customers или Suppliers
2. удалите 1 запись из Customers, которая была вами добавлена
3. изменить одну запись, из добавленных через UPDATE
4. Написать MERGE, который вставит вставит запись в клиенты, если ее там нет, и изменит если она уже есть
5. Напишите запрос, который выгрузит данные через bcp out и загрузить через bulk insert
*/

/*Для выполнения была выбрана таблица поставщики Suppliers*/


use [WideWorldImporters]
go

/*Данные из таблицы [Purchasing].[Suppliers] скопировала в  таблицу [Purchasing].Suppliers_Copy*/

drop table if exists [Purchasing].Suppliers_Copy
go

create table [Purchasing].Suppliers_Copy
(
    [SupplierID] [int] NOT NULL CONSTRAINT [DF_Purchasing_Suppliers_Copy_SupplierID]  DEFAULT (NEXT VALUE FOR [Sequences].[SupplierID]),
	[SupplierName] [nvarchar](100) NOT NULL,
	[SupplierCategoryID] [int] NOT NULL,
	[PrimaryContactPersonID] [int] NOT NULL,
	[AlternateContactPersonID] [int] NOT NULL,
	[DeliveryMethodID] [int] NULL,
	[DeliveryCityID] [int] NOT NULL,
	[PostalCityID] [int] NOT NULL,
	[SupplierReference] [nvarchar](20) NULL,
	[BankAccountName] [nvarchar](50) NULL,
	[BankAccountBranch] [nvarchar](50) NULL,
	[BankAccountCode] [nvarchar](20) NULL,
	[BankAccountNumber] [nvarchar](20) NULL,
	[BankInternationalCode] [nvarchar](20) NULL,
	[PaymentDays] [int] NOT NULL,
	[InternalComments] [nvarchar](max) NULL,
	[PhoneNumber] [nvarchar](20) NOT NULL,
	[FaxNumber] [nvarchar](20) NOT NULL,
	[WebsiteURL] [nvarchar](256) NOT NULL,
	[DeliveryAddressLine1] [nvarchar](60) NOT NULL,
	[DeliveryAddressLine2] [nvarchar](60) NULL,
	[DeliveryPostalCode] [nvarchar](10) NOT NULL,
	[DeliveryLocation] [geography] NULL,
	[PostalAddressLine1] [nvarchar](60) NOT NULL,
	[PostalAddressLine2] [nvarchar](60) NULL,
	[PostalPostalCode] [nvarchar](10) NOT NULL,
	[LastEditedBy] [int] NOT NULL,
 CONSTRAINT [PK_Purchasing_Suppliers_Copy] PRIMARY KEY CLUSTERED ( [SupplierID] ASC ),
 CONSTRAINT [UQ_Purchasing_Suppliers_Copy_SupplierName] UNIQUE NONCLUSTERED ( [SupplierName] ASC )
 )
GO 

insert into [Purchasing].Suppliers_Copy
(
       [SupplierID]
      ,[SupplierName]
      ,[SupplierCategoryID]
      ,[PrimaryContactPersonID]
      ,[AlternateContactPersonID]
      ,[DeliveryMethodID]
      ,[DeliveryCityID]
      ,[PostalCityID]
      ,[SupplierReference]
      ,[BankAccountName]
      ,[BankAccountBranch]
      ,[BankAccountCode]
      ,[BankAccountNumber]
      ,[BankInternationalCode]
      ,[PaymentDays]
      ,[InternalComments]
      ,[PhoneNumber]
      ,[FaxNumber]
      ,[WebsiteURL]
      ,[DeliveryAddressLine1]
      ,[DeliveryAddressLine2]
      ,[DeliveryPostalCode]
      ,[DeliveryLocation]
      ,[PostalAddressLine1]
      ,[PostalAddressLine2]
      ,[PostalPostalCode]
      ,[LastEditedBy] 
)
select top 5
       [SupplierID]
      ,[SupplierName]
      ,[SupplierCategoryID]
      ,[PrimaryContactPersonID]
      ,[AlternateContactPersonID]
      ,[DeliveryMethodID]
      ,[DeliveryCityID]
      ,[PostalCityID]
      ,[SupplierReference]
      ,[BankAccountName]
      ,[BankAccountBranch]
      ,[BankAccountCode]
      ,[BankAccountNumber]
      ,[BankInternationalCode]
      ,[PaymentDays]
      ,[InternalComments]
      ,[PhoneNumber]
      ,[FaxNumber]
      ,[WebsiteURL]
      ,[DeliveryAddressLine1]
      ,[DeliveryAddressLine2]
      ,[DeliveryPostalCode]
      ,[DeliveryLocation]
      ,[PostalAddressLine1]
      ,[PostalAddressLine2]
      ,[PostalPostalCode]
      ,[LastEditedBy] 
  from [Purchasing].Suppliers 
 GO

/*1. добавить 5 строк*/

insert into [Purchasing].Suppliers_Copy
(      [SupplierID],
       [SupplierName]
      ,[SupplierCategoryID]
      ,[PrimaryContactPersonID]
      ,[AlternateContactPersonID]
      ,[DeliveryMethodID]
      ,[DeliveryCityID]
      ,[PostalCityID]
      ,[SupplierReference]
      ,[BankAccountName]
      ,[BankAccountBranch]
      ,[BankAccountCode]
      ,[BankAccountNumber]
      ,[BankInternationalCode]
      ,[PaymentDays]
      ,[InternalComments]
      ,[PhoneNumber]
      ,[FaxNumber]
      ,[WebsiteURL]
      ,[DeliveryAddressLine1]
      ,[DeliveryAddressLine2]
      ,[DeliveryPostalCode]
      ,[DeliveryLocation]
      ,[PostalAddressLine1]
      ,[PostalAddressLine2]
      ,[PostalPostalCode]
      ,[LastEditedBy] 
)
output inserted.*
values (NEXT VALUE FOR [Sequences].[SupplierID], N'Nod Publishers (Double)', 2, 37, 38, 10, 10346, 10346, N'GL08029802', N'Nod Publishers (Double)', N'Woodgrove Bank Elizabeth City', 365985,2021545878, 48758, 7, null, N'(252) 555-0100',  N'(252) 555-0101', N'http://www.nodpublishers_2.com', N'Level 1', N'389 King Street', N'27906', null, N'PO Box 3390', N'Anderson', N'27906', 1),
       (NEXT VALUE FOR [Sequences].[SupplierID], N'Northwind Electric Cars (Double)', 3, 39, 40, 8, 7899, 7899, N'ML0300202', N'Northwind Electric Cars (Double)', N'Woodgrove Bank Crandon Lakes', 325447, 3258786987, 36214, 30, null, N'(201) 555-0105', N'(201) 555-0104', N'http://www.northwindelectriccars_2.com', N'', N'440 New Road', N'07860', null, N'PO Box 30920', N'Arlington', N'07860', 1),
	   (NEXT VALUE FOR [Sequences].[SupplierID], N'Trey Research (Double)', 8, 41, 42, null, 17277, 17277, N'082304822', N'Trey Research (Double)', N'Woodgrove Bank Kadoka', 658968, 1254785321, 56958, 7, null, N'(605) 555-0103', N'(605) 555-0101', N'http://www.treyresearch_2.net', N'Level 43', N'9401 Polar Avenue', N'57543', null, N'PO  Box 595', N'Port Fairy', N'57543', 1),
       (NEXT VALUE FOR [Sequences].[SupplierID], N'The Phone Company (Double)', 2, 43, 44, 7, 17346, 17346, N'237408032', N'The Phone Company (Double)', N'Woodgrove Bank Karlstad', 214568, 7896236589, 25478, 30, null, N'(218) 555-0105', N'(218) 555-0105', N'http://www.thephone-company_2.com', N'Level 83', N'339 Toorak Road', N'56732', null, N'PO Box 3837', N'Ferny Wood', N'56732', 1),
	   (NEXT VALUE FOR [Sequences].[SupplierID], N'Woodgrove Bank (Double)', 7, 45, 46, null, 30378, 30378, N'028034202', N'Woodgrove Bank (Double)', N'Woodgrove Bank San Francisco', 325698, 2147825698, 65893, 7, null, N'(415) 555-0103', N'(415) 555-0107', N'http://www.woodgrovebank_2.com', N'Level 3', N'8488 Vienna Boulevard', N'94101', null, N'PO Box 2390', N'Canterbury', N'94101', 1)

-- для  [Purchasing].Suppliers:
--insert into [Purchasing].Suppliers
--(      [SupplierID],
--       [SupplierName]
--      ,[SupplierCategoryID]
--      ,[PrimaryContactPersonID]
--      ,[AlternateContactPersonID]
--      ,[DeliveryMethodID]
--      ,[DeliveryCityID]
--      ,[PostalCityID]
--      ,[SupplierReference]
--      ,[BankAccountName]
--      ,[BankAccountBranch]
--      ,[BankAccountCode]
--      ,[BankAccountNumber]
--      ,[BankInternationalCode]
--      ,[PaymentDays]
--      ,[InternalComments]
--      ,[PhoneNumber]
--      ,[FaxNumber]
--      ,[WebsiteURL]
--      ,[DeliveryAddressLine1]
--      ,[DeliveryAddressLine2]
--      ,[DeliveryPostalCode]
--      ,[DeliveryLocation]
--      ,[PostalAddressLine1]
--      ,[PostalAddressLine2]
--      ,[PostalPostalCode]
--      ,[LastEditedBy] 
--)
--output inserted.*
--values (NEXT VALUE FOR [Sequences].[SupplierID], N'Nod Publishers (Double)', 2, 37, 38, 10, 10346, 10346, N'GL08029802', N'Nod Publishers (Double)', N'Woodgrove Bank Elizabeth City', 365985,2021545878, 48758, 7, null, N'(252) 555-0100',  N'(252) 555-0101', N'http://www.nodpublishers_2.com', N'Level 1', N'389 King Street', N'27906', null, N'PO Box 3390', N'Anderson', N'27906', 1),
--       (NEXT VALUE FOR [Sequences].[SupplierID], N'Northwind Electric Cars (Double)', 3, 39, 40, 8, 7899, 7899, N'ML0300202', N'Northwind Electric Cars (Double)', N'Woodgrove Bank Crandon Lakes', 325447, 3258786987, 36214, 30, null, N'(201) 555-0105', N'(201) 555-0104', N'http://www.northwindelectriccars_2.com', N'', N'440 New Road', N'07860', null, N'PO Box 30920', N'Arlington', N'07860', 1),
--	   (NEXT VALUE FOR [Sequences].[SupplierID], N'Trey Research (Double)', 8, 41, 42, null, 17277, 17277, N'082304822', N'Trey Research (Double)', N'Woodgrove Bank Kadoka', 658968, 1254785321, 56958, 7, null, N'(605) 555-0103', N'(605) 555-0101', N'http://www.treyresearch_2.net', N'Level 43', N'9401 Polar Avenue', N'57543', null, N'PO  Box 595', N'Port Fairy', N'57543', 1),
--       (NEXT VALUE FOR [Sequences].[SupplierID], N'The Phone Company (Double)', 2, 43, 44, 7, 17346, 17346, N'237408032', N'The Phone Company (Double)', N'Woodgrove Bank Karlstad', 214568, 7896236589, 25478, 30, null, N'(218) 555-0105', N'(218) 555-0105', N'http://www.thephone-company_2.com', N'Level 83', N'339 Toorak Road', N'56732', null, N'PO Box 3837', N'Ferny Wood', N'56732', 1),
--	   (NEXT VALUE FOR [Sequences].[SupplierID], N'Woodgrove Bank (Double)', 7, 45, 46, null, 30378, 30378, N'028034202', N'Woodgrove Bank (Double)', N'Woodgrove Bank San Francisco', 325698, 2147825698, 65893, 7, null, N'(415) 555-0103', N'(415) 555-0107', N'http://www.woodgrovebank_2.com', N'Level 3', N'8488 Vienna Boulevard', N'94101', null, N'PO Box 2390', N'Canterbury', N'94101', 1)


/*2. удалить последнюю добавленную запись*/
delete from [Purchasing].Suppliers_Copy
output  deleted.*
from [Purchasing].Suppliers_Copy
where [SupplierID] in (select top 1 [SupplierID] from [Purchasing].Suppliers_Copy order by [SupplierID] desc)

-- для  [Purchasing].Suppliers:
--delete from [Purchasing].Suppliers 
--output  deleted.*
--from [Purchasing].Suppliers 
--where [SupplierID] in (select top 5 [SupplierID] from [Purchasing].Suppliers  order by [SupplierID] desc)
    
/*3. изменить последнюю запись*/
update [Purchasing].Suppliers_Copy
   set [SupplierName] = concat([SupplierName], N' Изменили запись')
output deleted.*, inserted.*
from [Purchasing].Suppliers_Copy
where [SupplierID] in (select top 1 [SupplierID] from [Purchasing].Suppliers_Copy order by [SupplierID] desc)
 
-- для  [Purchasing].Suppliers:
--update [Purchasing].Suppliers
--   set [SupplierName] = concat([SupplierName], N' Изменили запись')
--output deleted.*, inserted.*
--from [Purchasing].Suppliers
--where [SupplierID] in (select top 1 [SupplierID] from [Purchasing].Suppliers order by [SupplierID] desc)


/*4. вставить запись, если ее там нет, и изменить если она уже есть*/
MERGE [Purchasing].Suppliers_Copy t
using (
select sup.[SupplierName]
      ,sup.[SupplierCategoryID]
      ,sup.[PrimaryContactPersonID]
      ,sup.[AlternateContactPersonID]
      ,sup.[DeliveryMethodID]
      ,sup.[DeliveryCityID]
      ,sup.[PostalCityID]
      ,sup.[SupplierReference]
      ,sup.[BankAccountName]
      ,sup.[BankAccountBranch]
      ,sup.[BankAccountCode]
      ,sup.[BankAccountNumber]
      ,sup.[BankInternationalCode]
      ,sup.[PaymentDays]
      ,sup.[InternalComments]
      ,sup.[PhoneNumber]
      ,sup.[FaxNumber]
      ,sup.[WebsiteURL]
      ,sup.[DeliveryAddressLine1]
      ,sup.[DeliveryAddressLine2]
      ,sup.[DeliveryPostalCode]
      ,sup.[DeliveryLocation]
      ,sup.[PostalAddressLine1]
      ,sup.[PostalAddressLine2]
      ,sup.[PostalPostalCode]
      ,sup.[LastEditedBy]
 from (values 
       ('Nod Publishers (Double)', 2, 37, 38, 10, 10346, 10346, N'GL08029802', N'Nod Publishers (Double)', N'Woodgrove Bank Elizabeth City', 365985,2021545878, 48758, 7, convert(nvarchar, null), N'(252) 555-0100',  N'(252) 555-0101', N'http://www.nodpublishers_2.com', N'Level 1', N'389 King Street', N'27906', convert(nvarchar, null), N'PO Box 3390', N'Anderson', N'27906', 1),
       (N'Northwind Electric Cars (Double)', 3, 39, 40, 8, 7899, 7899, N'ML0300202', N'Northwind Electric Cars (Double)', N'Woodgrove Bank Crandon Lakes', 325447, 3258786987, 36214, 30, convert(nvarchar, null), N'(201) 555-0105', N'(201) 555-0104', N'http://www.northwindelectriccars_2.com', N'', N'440 New Road', N'07860', convert(nvarchar, null), N'PO Box 30920', N'Arlington', N'07860', 1),
	   (N'Trey Research (Double)', 8, 41, 42, convert(int, null), 17277, 17277, N'082304822', N'Trey Research (Double)', N'Woodgrove Bank Kadoka', 658968, 1254785321, 56958, 7, convert(nvarchar, null), N'(605) 555-0103', N'(605) 555-0101', N'http://www.treyresearch_2.net', N'Level 43', N'9401 Polar Avenue', N'57543', convert(nvarchar, null), N'PO  Box 595', N'Port Fairy', N'57543', 1),
       (N'The Phone Company (Double)', 2, 43, 44, 7, 17346, 17346, N'237408032', N'The Phone Company (Double)', N'Woodgrove Bank Karlstad', 214568, 7896236589, 25478, 30, convert(nvarchar, null), N'(218) 555-0105', N'(218) 555-0105', N'http://www.thephone-company_2.com', N'Level 83', N'339 Toorak Road', N'56732', convert(nvarchar, null), N'PO Box 3837', N'Ferny Wood', N'56732', 1),
	   (N'Woodgrove Bank (Double)', 7, 45, 46, convert(int, null), 30378, 30378, N'028034202', N'Woodgrove Bank (Double)', N'Woodgrove Bank San Francisco', 325698, 2147825698, 65893, 7, convert(nvarchar, null), N'(415) 555-0103', N'(415) 555-0107', N'http://www.woodgrovebank_2.com', N'Level 3', N'8488 Vienna Boulevard', N'94101', convert(nvarchar, null), N'PO Box 2390', N'Canterbury', N'94101', 1)
	   ) sup 
	   ( 
       [SupplierName]
      ,[SupplierCategoryID]
      ,[PrimaryContactPersonID]
      ,[AlternateContactPersonID]
      ,[DeliveryMethodID]
      ,[DeliveryCityID]
      ,[PostalCityID]
      ,[SupplierReference]
      ,[BankAccountName]
      ,[BankAccountBranch]
      ,[BankAccountCode]
      ,[BankAccountNumber]
      ,[BankInternationalCode]
      ,[PaymentDays]
      ,[InternalComments]
      ,[PhoneNumber]
      ,[FaxNumber]
      ,[WebsiteURL]
      ,[DeliveryAddressLine1]
      ,[DeliveryAddressLine2]
      ,[DeliveryPostalCode]
      ,[DeliveryLocation]
      ,[PostalAddressLine1]
      ,[PostalAddressLine2]
      ,[PostalPostalCode]
      ,[LastEditedBy] ) 
) s
 on t.[SupplierName] = s.[SupplierName]
when matched then update set [SupplierName]            = s.[SupplierName]
                            ,[SupplierCategoryID]      = s.[SupplierCategoryID]
							,[PrimaryContactPersonID]  = s.[PrimaryContactPersonID]
							,[AlternateContactPersonID]= s.[AlternateContactPersonID]
							,[DeliveryMethodID]		   = s.[DeliveryMethodID]
							,[DeliveryCityID]		   = s.[DeliveryCityID]
							,[PostalCityID]			   = s.[PostalCityID]
							,[SupplierReference]	   = s.[SupplierReference]
							,[BankAccountName]		   = s.[BankAccountName]
							,[BankAccountBranch]	   = s.[BankAccountBranch]
							,[BankAccountCode]		   = s.[BankAccountCode]
							,[BankAccountNumber]	   = s.[BankAccountNumber]
							,[BankInternationalCode]   = s.[BankInternationalCode]
							,[PaymentDays]			   = s.[PaymentDays]
							,[InternalComments]		   = s.[InternalComments]
							,[PhoneNumber]			   = s.[PhoneNumber]
							,[FaxNumber]			   = s.[FaxNumber]
							,[WebsiteURL]			   = s.[WebsiteURL]
							,[DeliveryAddressLine1]	   = s.[DeliveryAddressLine1]
							,[DeliveryAddressLine2]	   = s.[DeliveryAddressLine2]
							,[DeliveryPostalCode]	   = s.[DeliveryPostalCode]
							,[DeliveryLocation]		   = s.[DeliveryLocation]
							,[PostalAddressLine1]	   = s.[PostalAddressLine1]
							,[PostalAddressLine2]	   = s.[PostalAddressLine2]
							,[PostalPostalCode]		   = s.[PostalPostalCode]
							,[LastEditedBy]			   = s.[LastEditedBy]
when not matched then insert ( [SupplierName]
							  ,[SupplierCategoryID]
							  ,[PrimaryContactPersonID]
							  ,[AlternateContactPersonID]
							  ,[DeliveryMethodID]
							  ,[DeliveryCityID]
							  ,[PostalCityID]
							  ,[SupplierReference]
							  ,[BankAccountName]
							  ,[BankAccountBranch]
							  ,[BankAccountCode]
							  ,[BankAccountNumber]
							  ,[BankInternationalCode]
							  ,[PaymentDays]
							  ,[InternalComments]
							  ,[PhoneNumber]
							  ,[FaxNumber]
							  ,[WebsiteURL]
							  ,[DeliveryAddressLine1]
							  ,[DeliveryAddressLine2]
							  ,[DeliveryPostalCode]
							  ,[DeliveryLocation]
							  ,[PostalAddressLine1]
							  ,[PostalAddressLine2]
							  ,[PostalPostalCode]
							  ,[LastEditedBy] 
						) values ( s.[SupplierName]
							  ,s.[SupplierCategoryID]
							  ,s.[PrimaryContactPersonID]
							  ,s.[AlternateContactPersonID]
							  ,s.[DeliveryMethodID]
							  ,s.[DeliveryCityID]
							  ,s.[PostalCityID]
							  ,s.[SupplierReference]
							  ,s.[BankAccountName]
							  ,s.[BankAccountBranch]
							  ,s.[BankAccountCode]
							  ,s.[BankAccountNumber]
							  ,s.[BankInternationalCode]
							  ,s.[PaymentDays]
							  ,s.[InternalComments]
							  ,s.[PhoneNumber]
							  ,s.[FaxNumber]
							  ,s.[WebsiteURL]
							  ,s.[DeliveryAddressLine1]
							  ,s.[DeliveryAddressLine2]
							  ,s.[DeliveryPostalCode]
							  ,s.[DeliveryLocation]
							  ,s.[PostalAddressLine1]
							  ,s.[PostalAddressLine2]
							  ,s.[PostalPostalCode]
							  ,s.[LastEditedBy])
output deleted.*, $action, inserted.*;


select [SupplierID]
      ,[SupplierName]
	  ,[SupplierCategoryID]
	  ,[PrimaryContactPersonID]
	  ,[AlternateContactPersonID]
	  ,[DeliveryMethodID]
	  ,[DeliveryCityID]
	  ,[PostalCityID]
	  ,[SupplierReference]
	  ,[BankAccountName]
	  ,[BankAccountBranch]
	  ,[BankAccountCode]
	  ,[BankAccountNumber]
	  ,[BankInternationalCode]
	  ,[PaymentDays]
	  ,[InternalComments]
	  ,[PhoneNumber]
	  ,[FaxNumber]
	  ,[WebsiteURL]
	  ,[DeliveryAddressLine1]
	  ,[DeliveryAddressLine2]
	  ,[DeliveryPostalCode]
	  ,[DeliveryLocation]
	  ,[PostalAddressLine1]
	  ,[PostalAddressLine2]
	  ,[PostalPostalCode]
	  ,[LastEditedBy] 
from [Purchasing].Suppliers_Copy


/*5. Напишите запрос, который выгрузит данные через bcp out и загрузить через bulk insert*/

/*
Msg 15281, Level 16, State 1, Procedure master..xp_cmdshell, Line 1 [Batch Start Line 0]
SQL Server blocked access to procedure 'sys.xp_cmdshell' of component 'xp_cmdshell' because this component is turned off as part of the security configuration for this server. 
A system administrator can enable the use of 'xp_cmdshell' by using sp_configure. For more information about enabling 'xp_cmdshell', search for 'xp_cmdshell' in SQL Server Books Online.
*/

-- To allow advanced options to be changed.  
EXEC sp_configure 'show advanced options', 1;  
GO  
-- To update the currently configured value for advanced options.  
RECONFIGURE;  
GO  
-- To enable the feature.  
EXEC sp_configure 'xp_cmdshell', 1;  
GO  
-- To update the currently configured value for this feature.  
RECONFIGURE;  
GO 

begin
    declare @ServerName nvarchar(255) = @@SERVERNAME, @Cmd nvarchar(4000);
    set @Cmd = 'bcp "[WideWorldImporters].[Purchasing].Suppliers_Copy" out  "D:\1\Suppliers_Copy_1.txt" -T -w -t, -S '+ @ServerName
	exec master..xp_cmdshell @Cmd, no_output
	set @Cmd = 'bcp "[WideWorldImporters].[Purchasing].Suppliers_Copy" out  "D:\1\Suppliers_Copy_2.txt" -T -w -t"@eu&$1&" -S '+ @ServerName
    exec master..xp_cmdshell @Cmd
end

begin

drop table if exists [Purchasing].Suppliers_Copy_Bulk
 
create table [Purchasing].Suppliers_Copy_Bulk
(
    [SupplierID] [int] NOT NULL CONSTRAINT [DF_Purchasing_Suppliers_Copy_Bulk_SupplierID]  DEFAULT (NEXT VALUE FOR [Sequences].[SupplierID]),
	[SupplierName] [nvarchar](100) NOT NULL,
	[SupplierCategoryID] [int] NOT NULL,
	[PrimaryContactPersonID] [int] NOT NULL,
	[AlternateContactPersonID] [int] NOT NULL,
	[DeliveryMethodID] [int] NULL,
	[DeliveryCityID] [int] NOT NULL,
	[PostalCityID] [int] NOT NULL,
	[SupplierReference] [nvarchar](20) NULL,
	[BankAccountName] [nvarchar](50) NULL,
	[BankAccountBranch] [nvarchar](50) NULL,
	[BankAccountCode] [nvarchar](20) NULL,
	[BankAccountNumber] [nvarchar](20) NULL,
	[BankInternationalCode] [nvarchar](20) NULL,
	[PaymentDays] [int] NOT NULL,
	[InternalComments] [nvarchar](max) NULL,
	[PhoneNumber] [nvarchar](20) NOT NULL,
	[FaxNumber] [nvarchar](20) NOT NULL,
	[WebsiteURL] [nvarchar](256) NOT NULL,
	[DeliveryAddressLine1] [nvarchar](60) NOT NULL,
	[DeliveryAddressLine2] [nvarchar](60) NULL,
	[DeliveryPostalCode] [nvarchar](10) NOT NULL,
	[DeliveryLocation] [geography] NULL,
	[PostalAddressLine1] [nvarchar](60) NOT NULL,
	[PostalAddressLine2] [nvarchar](60) NULL,
	[PostalPostalCode] [nvarchar](10) NOT NULL,
	[LastEditedBy] [int] NOT NULL,
 CONSTRAINT [PK_Purchasing_Suppliers_Copy_Bulk] PRIMARY KEY CLUSTERED ( [SupplierID] ASC ),
 CONSTRAINT [UQ_Purchasing_Suppliers_Copy_Bulk_SupplierName] UNIQUE NONCLUSTERED ( [SupplierName] ASC )
 ) 

BULK INSERT [WideWorldImporters].[Purchasing].Suppliers_Copy_Bulk
   FROM "D:\1\Suppliers_Copy_2.txt"
   WITH 
	 (
		BATCHSIZE = 1000, 
		DATAFILETYPE = 'widechar',
		FIELDTERMINATOR = '@eu&$1&',
		ROWTERMINATOR ='\n',
		KEEPNULLS,
		TABLOCK        
	  );

select [SupplierID]
      ,[SupplierName]
	  ,[SupplierCategoryID]
	  ,[PrimaryContactPersonID]
	  ,[AlternateContactPersonID]
	  ,[DeliveryMethodID]
	  ,[DeliveryCityID]
	  ,[PostalCityID]
	  ,[SupplierReference]
	  ,[BankAccountName]
	  ,[BankAccountBranch]
	  ,[BankAccountCode]
	  ,[BankAccountNumber]
	  ,[BankInternationalCode]
	  ,[PaymentDays]
	  ,[InternalComments]
	  ,[PhoneNumber]
	  ,[FaxNumber]
	  ,[WebsiteURL]
	  ,[DeliveryAddressLine1]
	  ,[DeliveryAddressLine2]
	  ,[DeliveryPostalCode]
	  ,[DeliveryLocation]
	  ,[PostalAddressLine1]
	  ,[PostalAddressLine2]
	  ,[PostalPostalCode]
	  ,[LastEditedBy]  
  from [Purchasing].Suppliers_Copy_Bulk
end

drop table if exists [Purchasing].Suppliers_Copy
go

drop table if exists [Purchasing].Suppliers_Copy_Bulk
go

/*Сбросить счетчик последовательности [Sequences].[SupplierID]*/
/*или явно ALTER SEQUENCE [Sequences].[SupplierID] RESTART WITH 14;*/
BEGIN 
    declare @start_value nvarchar(10)
	SELECT @start_value = cast(start_value  as nvarchar(10)) FROM sys.sequences WHERE [name] = 'SupplierID'
    DECLARE @resetSQL nvarchar(255) = 'ALTER SEQUENCE [Sequences].[SupplierID] RESTART WITH ' + @start_value;

    exec sp_executesql @resetSQL;
end
go
 
